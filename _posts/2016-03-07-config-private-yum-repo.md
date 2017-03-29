---
layout: post
title: 搭建私有 yum 仓库
description: "搭建私有 yum 仓库"
category: Linux
avatarimg:
tags: [Linux, Yum]
duoshuo: true
---


# 引言

上一篇文章说的是构建 rpm 包，接下来说说如何构建公司内部 yum 源。


## 服务端配置

```bash

# 1. 创建 yum 仓库目录，rpm 包都上至此目录
mkdir -p /application/yum/centos6/x86_64/    

# 2. 安装 createrepo 软件
yum -y install createrepo                    

# 3. 初始化 repodata 索引文件
createrepo -pdo /application/yum/centos6/x86_64/ /application/yum/centos6/x86_64/     

# 4. 进入需要提供仓库的目录
cd /application/yum/centos6/x86_64/          

# 5. 可以用 Apache 或 Nginx 提供 Web 服务
# 但用 Python 的 http 模块更简单，适用于内网环境，可以通过浏览器输入本机 IP 查看。
python -m SimpleHTTPServer 80 &>/dev/null &  

# 6. 每加入一个 rpm 包就要更新一下
createrepo –update /application/yum/centos6/x86_64/       

# 修改 yum 配置文件 keepacache=0 改为 1，保存下载过的软件
sed -i ‘s#keepcache=0#keepcache=1#g’ /etc/yum.conf         

```    


## 客户端配置

```bash

cd /etc/yum.repos.d

vi jamin.repo          # 连接本地 yum 源
repo 文件内容如下：
[jamin]
name=Server
baseurl=http://$LAN_IP
enable=1
gpgcheck=0

yum –-enablerepo=jamin –-disablerepo=base,extras,updates,epel list # 指定使用 jamin 库(临时生效)

```    

## yum 源同步

暂时没做，具体可参考 Ref 中的配置

# Ref
[自动化部署必备技能—搭建 YUM 仓库](http://www.xuliangwei.com/xubusi/40.html)  
[CentOS 下挂载 ISO](http://www.centoscn.com/CentOS/config/2014/0525/3020.html)  
