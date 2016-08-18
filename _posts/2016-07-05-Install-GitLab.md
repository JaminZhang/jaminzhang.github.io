---
layout: post
title: 安装 GitLab
description: "安装 GitLab"
category: Git
avatarimg:
tags: [Git, GitLab]
duoshuo: true
---

本文在 CentOS 7 下安装。  

## 1 安装配置必要的依赖

```bash
yum install curl policycoreutils openssh-server openssh-clients -y
systemctl enable sshd
systemctl start sshd
yum install postfix
systemctl enable postfix
systemctl start postfix
```    

## 2 添加 GitLab yum 源并安装 GitLab-CE 包

>
由于国内的网络问题，连接 GitLab 官方 yum 源比较慢，官方提示可以使用清华大学的镜像源。


```bash
vim /etc/yum.repos.d/gitlab-ce.repo 
[gitlab-ce]
name=gitlab-ce
baseurl=http://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7
repo_gpgcheck=0
gpgcheck=0
enabled=1
gpgkey=https://packages.gitlab.com/gpg.key

yum makecache
yum install gitlab-ce -y

```    

## 3 配置启动 GitLab

>
gitlab-ctl reconfigure

可以使用 gitlab-ctl 管理 GitLab，例如查看 GitLab 状态：

```bash
[root@linux-node2 ~]# gitlab-ctl status
run: gitlab-workhorse: (pid 13513) 40s; run: log: (pid 13360) 62s
run: logrotate: (pid 13378) 60s; run: log: (pid 13377) 60s
run: nginx: (pid 13366) 61s; run: log: (pid 13365) 61s
run: postgresql: (pid 13017) 266s; run: log: (pid 13016) 266s
run: redis: (pid 12910) 293s; run: log: (pid 12909) 293s
run: sidekiq: (pid 13349) 68s; run: log: (pid 13348) 68s
run: unicorn: (pid 13687) 3s; run: log: (pid 13316) 75s

```    

## 4 浏览登录 GitLab

第一次访问，会重定向到密码重置页面，此时设置系统管理员账号密码。默认管理员账号的用户名是 root。登录之后，可以更改用户名。

# 遇到的问题

安装完成后，登录提示 502，查看 unicorn 日志，发现 8080 端口占用冲突，关掉之前环境启动的 nginx 就正常了。

```bash
tail -f  /var/log/gitlab/unicorn/unicorn_stderr.log 

I, [2016-08-05T11:56:59.909729 #15241]  INFO -- : Refreshing Gem list
E, [2016-08-05T11:57:08.930848 #15241] ERROR -- : adding listener failed addr=127.0.0.1:8080 (in use)
E, [2016-08-05T11:57:08.930938 #15241] ERROR -- : retrying in 0.5 seconds (4 tries left)
E, [2016-08-05T11:57:09.432554 #15241] ERROR -- : adding listener failed addr=127.0.0.1:8080 (in use)
E, [2016-08-05T11:57:09.432663 #15241] ERROR -- : retrying in 0.5 seconds (3 tries left)
E, [2016-08-05T11:57:09.933172 #15241] ERROR -- : adding listener failed addr=127.0.0.1:8080 (in use)
E, [2016-08-05T11:57:09.933364 #15241] ERROR -- : retrying in 0.5 seconds (2 tries left)
E, [2016-08-05T11:57:10.434686 #15241] ERROR -- : adding listener failed addr=127.0.0.1:8080 (in use)
E, [2016-08-05T11:57:10.434989 #15241] ERROR -- : retrying in 0.5 seconds (1 tries left)
E, [2016-08-05T11:57:10.936107 #15241] ERROR -- : adding listener failed addr=127.0.0.1:8080 (in use)
E, [2016-08-05T11:57:10.936261 #15241] ERROR -- : retrying in 0.5 seconds (0 tries left)
E, [2016-08-05T11:57:11.437084 #15241] ERROR -- : adding listener failed addr=127.0.0.1:8080 (in use)
/opt/gitlab/embedded/service/gem/ruby/2.1.0/gems/unicorn-4.9.0/lib/unicorn/socket_helper.rb:185:in `bind': Address already in use - bind(2) for 127.0.0.1:8080 (Errno::EADDRINUSE)
```    

# Ref
[Install a GitLab CE Omnibus package](https://about.gitlab.com/downloads/#centos7)  
[Gitlab Community Edition 镜像使用帮助](https://mirror.tuna.tsinghua.edu.cn/help/gitlab-ce/)  


