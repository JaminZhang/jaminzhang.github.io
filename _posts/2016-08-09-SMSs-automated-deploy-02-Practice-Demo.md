---
layout: post
title: 中小企业自动化部署 02 - 实践演示
description: "中小企业自动化部署 02 - 实践演示"
category: CI/CD
avatarimg:
tags: [CI/CD, Deploy, Shell]
duoshuo: true
---

# 引言

前一篇文章，说明了自动化部署的目标及流程，现在我们拿运维工程师熟悉的 Shell 来实践这个流程。

# 规划

1. 用户配置（所有的 Web 服务都应该使用普通用户，一个生产实践：所有的 Web 服务不监听 80 端口，而是由负载均衡来监听。）
2. 部署机到目标机的 SSH 免密钥配置
3. 部署目录规划及配置
4. 目标机 Webroot 配置（本文实例演示使用 httpd ）


# GitLab 配置

使用 GitLab 管理公司项目代码仓库

1. 修改 external_url 等 
2. 关闭注册 
3. 先创建组，再创建项目
4. 部署机拉取 GitLab 项目仓库配置 （本文 192.168.56.11 作为部署机，192.168.56.11/12 也作为部署的目标机）
5. 开发机 git push 配置 （本文 192.168.56.12 作为开发机）


```bash

# 在部署机创建部署目录放置代码、配置文件、压缩包等
mkdir -p /deploy/code/web-demo		
mkdir -p /deploy/config/web-demo/base
mkdir -p /deploy/config/web-demo/other
mkdir -p /deploy/tar
mkdir -p /deploy/tmp
chown -R www:www /deploy

# 在目标机上创建代码、配置等的放置目录
mkdir -p /opt/webroot
mkdir /webroot
chown -R www:www /opt/webroot
chown -R www:www /webroot

```   

# 自动化部署及回滚脚本

内容如下：

```bash

#!/bin/bash

# Node List
PRE_LIST="192.168.56.11"		# 预生产环境节点
GROUP1_LIST="192.168.56.12"		# 分组 1
ROLLBACK_LIST="192.168.56.11 192.168.56.12" # 回滚列表

# Date/Time Veriables
LOG_DATE='date "+%Y-%m-%d"'
LOG_TIME='date "+%H-%M-%S"'

CDATE=$(date "+%Y-%m-%d")
CTIME=$(date "+%H-%M-%S")

# Shell Env
SHELL_NAME="deploy_all.sh"
SHELL_DIR="/home/www/"
SHELL_LOG="${SHELL_DIR}/${SHELL_NAME}.log"

# Code Env
PRO_NAME="web-demo"
CODE_DIR="/deploy/code/web-demo"
CONFIG_DIR="/deploy/config/web-demo"
TMP_DIR="/deploy/tmp"
TAR_DIR="/deploy/tar"
LOCK_FILE="/tmp/deploy.lock"

usage(){
	echo $"Usage: $0 {deploy | rollback [ list | version ]}"
}

writelog(){
   LOGINFO=$1
   echo "${CDATE} ${CTIME}: ${SHELL_NAME} : ${LOGINFO} "  >> ${SHELL_LOG}
}

shell_lock(){
	touch ${LOCK_FILE}
}

shell_unlock(){
	rm -f ${LOCK_FILE}
}

url_test(){
	URL=$1
	curl -s --head $URL | grep '200 OK'
	if [ $? -ne 0 ]; then
		shell_unlock;
		echo "test error" && exit;
	fi
}

code_get(){
	writelog "code_get";
	cd $CODE_DIR && git pull		# 事先要在部署机上 git clone 项目代码
	cp -r ${CODE_DIR} ${TMP_DIR}/
	API_VERL=$(git show | grep commit | cut -d ' ' -f2)
	API_VER=$(echo ${API_VERL:0:6})
}

code_build(){
	echo code_build
}


code_config(){
	writelog "code_config"
	/bin/cp -r ${CONFIG_DIR}/base/* ${TMP_DIR}/"${PRO_NAME}"
	PKG_NAME="${PRO_NAME}"_"$API_VER"_"${CDATE}-${CTIME}"
	cd ${TMP_DIR} && mv ${PRO_NAME} ${PKG_NAME}
}

code_tar(){
	writelog "code_tar"
	cd ${TMP_DIR} && tar czf ${PKG_NAME}.tar.gz ${PKG_NAME}
	writelog "${PKG_NAME}.tar.gz"
}

code_scp(){
	writelog "code_scp"
	for node in $PRE_LIST;do
		scp ${TMP_DIR}/${PKG_NAME}.tar.gz $node:/opt/webroot/
	done

	for node in $GROUP1_LIST;do
		scp ${TMP_DIR}/${PKG_NAME}.tar.gz $node:/opt/webroot/
	done
}

pre_deploy(){
	writelog "remove from cluster"
	ssh $PRE_LIST "cd /opt/webroot && tar zxf ${PKG_NAME}.tar.gz"
	ssh $PRE_LIST "rm -f /webroot/web-demo && ln -s /opt/webroot/${PKG_NAME} /webroot/web-demo"
}

pre_test(){
	url_test "http://${PRE_LIST}/index.html"
	echo "add to cluster"
}

group1_deploy(){
	writelog "remove from cluster"
	for node in $GROUP1_LIST;do
		ssh $node "cd /opt/webroot && tar zxf ${PKG_NAME}.tar.gz"
		ssh $node "rm -f /webroot/web-demo && ln -s /opt/webroot/${PKG_NAME} /webroot/web-demo"
	done
	scp ${CONFIG_DIR}/other/192.168.56.12.crontab.xml 192.168.56.12:/webroot/web-demo/crontab.xml
}

group1_test(){
	url_test "http://192.168.56.12:8081/index.html"		# 192.168.56.12 80 端口被 GitLab Nginx 占用
	echo "add to cluster"
}

rollback_fun(){
	for node in $ROLLBACK_LIST;do
	ssh $node "rm -f /webroot/web-demo && ln -s /opt/webroot/$1 /webroot/web-demo"
	done
}

rollback(){
if [ -z $1 ];then
	shell_unlock;
	echo "Please input rollback version" && exit;
fi
    case $1 in
	list)
		ls -l /opt/webroot/*.tar.gz
		;;
	*)
		rollback_fun $1
    esac
}

main(){
   if [ -f $LOCK_FILE ];then
	echo "Deploy is running" && exit;
   fi
    DEPLOY_METHOD=$1
    ROLLBACK_VER=$2
    case $DEPLOY_METHOD in
	deploy)
		shell_lock;
		code_get;
		code_build;
		code_config;
		code_tar;
		code_scp;
		pre_deploy;
		pre_test;
		group1_deploy;
		group1_test;
		shell_unlock;
		;;
	rollback)
		shell_lock;
		rollback $ROLLBACK_VER;
		shell_unlock;
		;;
	*)
		usage;
    esac
}
main $1 $2

```    

以上 Shell 脚本简单实现从 GitLab 拉取最新代码自动部署到目标机和一键回滚到任意版本。

以下为使用方法演示：

```bash

# 自动部署最新版本
[www@linux-node1 ~]$ ./deploy_all.sh deploy
remote: Counting objects: 3, done.
remote: Total 3 (delta 0), reused 0 (delta 0)
Unpacking objects: 100% (3/3), done.
From 192.168.56.12:web/web-demo
   902aff1..fec4758  master     -> origin/master
Updating 902aff1..fec4758
Fast-forward
 index.html | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
code_build
web-demo_fec475_2016-08-09-17-11-22.tar.gz                                                                                                                                      100% 8570     8.4KB/s   00:00    
web-demo_fec475_2016-08-09-17-11-22.tar.gz                                                                                                                                      100% 8570     8.4KB/s   00:00    
HTTP/1.1 200 OK
add to cluster
192.168.56.12.crontab.xml                                                                                                                                                       100%   38     0.0KB/s   00:00    
HTTP/1.1 200 OK
add to cluster

# 回滚时的版本列表
[www@linux-node1 ~]$ ./deploy_all.sh rollback list
-rw-rw-r-- 1 www www 8031 Aug  9 16:43 /opt/webroot/web-demo_902aff_2016-08-09-16-43-19.tar.gz
-rw-rw-r-- 1 www www 8030 Aug  9 17:10 /opt/webroot/web-demo_902aff_2016-08-09-17-10-08.tar.gz
-rw-rw-r-- 1 www www 8570 Aug  9 17:11 /opt/webroot/web-demo_fec475_2016-08-09-17-11-22.tar.gz

# 回滚到指定版本
[www@linux-node1 ~]$ ./deploy_all.sh rollback web-demo_902aff_2016-08-09-17-10-08

```    

# 总结

<pre> 

在 IT 管理里面有三大核心要素是 PPT，也就是人员/组织架构（People）、流程（Process）、技术/工具（Tech/Tool）。
所以说设计一个自动化部署系统，并不是上线几个工具，写几个自动化脚本这么简单。
设计一个流程，除了流程本身要和我们的组织架构、人员和技术挂钩，而且还要根据企业的实际情况来做，不能好高骛远，
一上来就设计一个庞大的自动化部署平台，可能并不符合企业现状，又浪费了资源。
其次，所有架构和流程的设计都是基于业务需求的，那么不同的业务场景，不同的需求可能出现不同的自动化部署的流程和步骤，
所以本文仅供大家参考。
最后，还有一点就是流程和思路很重要，具体的实现方法很多，
看团队的技术水平，可以使用 Python、Shell、PHP 等来实现，不要被某些工具所束缚就行。

</pre>

# Ref
[中小企业自动化部署实践](https://www.unixhot.com/article/31) 
