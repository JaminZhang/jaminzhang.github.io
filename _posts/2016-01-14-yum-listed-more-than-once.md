---
layout: post
title: yum repository listed more than once
description: "yum repository listed more than once"
category: Linux
avatarimg:
tags: [yum]
duoshuo: true
---

# 引言
服务器上使用yum命令更新软件上提示如下：  
yum repository xxx is listed more than once

# 错误原因及解决方法
根据字面上的提示，是说yum仓库列出来不止一次。  
一般可能的原因是多个repo文件中指定了yum仓库多次。
我查看了服务器下/etc/yum.repo.d/下的repo文件，确实是yum仓库被指定了2次。

<pre>

[root@xxx_game ~]# grep -i "\[base\]" /etc/yum.repos.d/*.repo -A 5
/etc/yum.repos.d/CentOS-Base.repo:[base]
/etc/yum.repos.d/CentOS-Base.repo-name=CentOS-$releasever - Base
/etc/yum.repos.d/CentOS-Base.repo-mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os&infra=$infra
/etc/yum.repos.d/CentOS-Base.repo-#baseurl=http://mirror.centos.org/centos/$releasever/os/$basearch/
/etc/yum.repos.d/CentOS-Base.repo-gpgcheck=1
/etc/yum.repos.d/CentOS-Base.repo-gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
--
/etc/yum.repos.d/xxstack.repo:[base]
/etc/yum.repos.d/xxstack.repo-name=CentOS-6 - Base
/etc/yum.repos.d/xxstack.repo-mirrorlist=http://yum.xxx.cc:81/mirrorlist/centos_base.mirrorlist
/etc/yum.repos.d/xxstack.repo-gpgcheck=1
/etc/yum.repos.d/xxstack.repo-gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
/etc/yum.repos.d/xxstack.repo-

</pre>

解决方法：可以删除多余的yum仓库条目。但我这边并没有删除多余的yum repo文件，重复的都是一般通用的库，更新通用库的软件应该没什么问题，  
公司内部使用的yum仓库里面有自定义yum软件，并没有重复的。

# Ref
[is “yum repository is listed more than once” a system error?](http://stackoverflow.com/questions/22662349/is-yum-repository-is-listed-more-than-once-a-system-error)  



