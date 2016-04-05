---
layout: post
title: 搭建私有YUM仓库
description: "搭建私有YUM仓库"
category: Linux
avatarimg:
tags: [YUM]
duoshuo: true
---


# 引言
上一篇文章说的是构建rpm包，接下来说说如何构建公司内部yum源。


## 服务端配置
<pre>
mkdir -p /application/yum/centos6/x86_64/    #1.创建yum仓库目录,rpm包都上至此目录

yum -y install createrepo                    #2.安装createrepo软件

createrepo -pdo /application/yum/centos6/x86_64/ /application/yum/centos6/x86_64/     #3.初始化repodata索引文件

cd /application/yum/centos6/x86_64/          #4.进入需要提供仓库的目录

python -m SimpleHTTPServer 80 &>/dev/null &  #5.可以用Apache或nginx提供web服务，但用Python的http模块更简单，适用于内网环境, 可以通过浏览器输入本机IP查看。

createrepo –update /application/yum/centos6/x86_64/        #6.每加入一个rpm包就要更新一下

sed -i ‘s#keepcache=0#keepcache=1#g’ /etc/yum.conf         #修改yum配置文件keepacache=0改为1，保存下载过的软件
</pre>


## 客户端配置
<pre>
cd /etc/yum.repos.d

vi jamin.repo          #连接本地yum源
repo文件内容如下：
[jamin]
name=Server
baseurl=http://$LAN_IP
enable=1
gpgcheck=0
yum –-enablerepo=jamin –-disablerepo=base,extras,updates,epel list #指定使用jamin库(临时生效)
</pre>

## yum源同步
暂时没做，具体可参考Ref中的配置

# Ref
[自动化部署必备技能—搭建YUM仓库](http://www.xuliangwei.com/xubusi/40.html)  
[CentOS下挂载ISO](http://www.centoscn.com/CentOS/config/2014/0525/3020.html)  
