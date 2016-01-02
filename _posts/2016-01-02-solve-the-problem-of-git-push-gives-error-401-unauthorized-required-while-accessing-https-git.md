---
layout: post
title: git push提示401 Unauthorized while accessing https的原因及解决方法
description: "git push提示401 Unauthorized while accessing https的原因及解决方法"
category: Linux
avatarimg:
tags: [Linux, Git]
duoshuo: true
---

# 引言
昨天开始重新学习Git的基础知识，很久时间不用了，就容易忘记。 

# 错误提示
当执行git push命令时，提示"401 Unauthorized while accessing https"，如下：
<pre>
[root@Aliyun-BJ-01 tutorial]# git push
error: The requested URL returned error: 401 Unauthorized while accessing https://jaminzhang.backlogtool.com/git/JAMIN_GIT/tutorial.git/info/refs

fatal: HTTP request failed
</pre>

# 原因分析
教程中并没有报错，检查半天，发现其他配置都一样，然后怀疑是使用的git版本不一样。我使用的CentOS系统，yum install git安装的最新版本是1.7.1，其实这个版本比较老了，有关于认证方面的一个限制，就是用户名是需要严格声明的。
从这里可以看出常作为服务器系统的CentOS上的软件一般还是以稳定为主，yum源中的很多软件并不新。

# 解决方法
从上面知道原因了，就可以知道解决方法了。下面提供2个。
## 1、手动安装一个新版本的git
这个看起来够直接，但其实也不是那么简单，一般默认源都是安装git 1.7.1，我有些懒，不想找提供比这个版本更高的yum源或者从源码安装，这个方法暂时没用。  
从上面的描述也可以看出，CentOS还是作为服务器使用吧，个人使用不太方便。

## 2、在git repo link中添加username用户名字段
先删除掉远程库，然后添加username用户名字段（https://[用户名字段]@）到git repo link中，再重新添加远程库，  
然后git push，发现不需要输入用户名了，直接提示输入密码，输入正确的密码后就可以进行push了。
<pre>
[root@Aliyun-BJ-01 tutorial]# git remote rm origin
[root@Aliyun-BJ-01 tutorial]# git remote add origin https://Jamin.Zhang@jaminzhang.backlogtool.com/git/JAMIN_GIT/tutorial.git
[root@Aliyun-BJ-01 tutorial]# git push
Password: 
Counting objects: 5, done.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 334 bytes, done.
Total 3 (delta 1), reused 0 (delta 0)
To https://Jamin.Zhang@jaminzhang.backlogtool.com/git/JAMIN_GIT/tutorial.git
   703bd79..b961c67  master -> master
</pre>

# Ref
[git pull gives error: 401 Authorization Required while accessing https://git.foo.com/bar.git](http://stackoverflow.com/questions/16572286/git-pull-gives-error-401-authorization-required-while-accessing-https-git-foo)  
[push到远程数据库](http://backlogtool.com/git-guide/cn/intro/intro4_2.html)  
