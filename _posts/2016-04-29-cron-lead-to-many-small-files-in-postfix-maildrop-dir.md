---
layout: post
title: cron引起/var/spool/postfix/maildrop目录生成大量小文件
description: "cron引起/var/spool/postfix/maildrop目录生成大量小文件"
category: Linux
avatarimg:
tags: [cron, postfix]
duoshuo: true
---

# 引言
刚才接到某台服务器的磁盘占用空间报警，根据经验，我猜测是/var/目录占用空间过大。  
于是登录服务器，果然，确认了是/var/spool/postfix/maildrop目录占用较大空间，里面有大量小文件。
下面排查下原因。很多人遇到了这个问题，是cron引起的。

# cron原理

> 
Cron  searches  /var/spool/cron  for crontab files which are named after accounts in /etc/passwd; The founded crontabs are loaded into memory.  Cron also searches for /etc/anacrontab
and the files in the /etc/cron.d directory, which are in a different format (see crontab(5) ).  Cron examines all stored crontabs, checking each command to see if it should be run in
the  current  minute.  When  executing  commands,  any  output  is mailed to the owner of the crontab (or to the user named in the MAILTO environment variable in the crontab, if such
exists).  Job output can also be sent to syslog by using the -s option.

# 原因分析
> 
由于Linux在执行cron时，会将cron执行脚本中的output和warning信息，都会以邮件的形式发送Cron所有者， 而由于服务器上的sendmail或postfix没有正常运行，
导致邮件发送不成功，全部小文件堆积在了maildrop目录下面，而且没有自动清理转换的机制，经历较长时间后，此目录已堆积了大量的文件。查看man cron的信息，可以知道会发送给cron owner.
（注意：如果sendmail或者postfix正常运行，则会在/var/mail目录下产生大量的邮件，也会堆积)

以下为/var/spool/postfix/maildrop目录下某个邮件首部的内容（里面发件人就是from root Cron Daemon）：

```bash
[root@xxx_game maildrop]# postcat -q B5F89264241 | head -19
postcat: warning: inet_protocols: IPv6 support is disabled: Address family not supported by protocol
postcat: warning: inet_protocols: configuring for IPv4 support only
*** ENVELOPE RECORDS maildrop/B5F89264241 ***
message_arrival_time: Fri Apr 29 08:37:01 2016
named_attribute: rewrite_context=local
sender_fullname: CronDaemon
sender: root
*** MESSAGE CONTENTS maildrop/B5F89264241 ***
From: root (Cron Daemon)
To: root
Subject: Cron <root@xxx_game> /usr/bin/python /usr/local/sbin/xxx.py
Content-Type: text/plain; charset=ANSI_X3.4-1968
Auto-Submitted: auto-generated
X-Cron-Env: <LC_ALL=C>
X-Cron-Env: <LANG=en_US.UTF-8>
X-Cron-Env: <SHELL=/bin/sh>
X-Cron-Env: <HOME=/root>
X-Cron-Env: <PATH=/usr/bin:/bin>
X-Cron-Env: <LOGNAME=root>
X-Cron-Env: <USER=root>

```    


# 解决方案

在crontab的第一行加入 MAILTO=""便可，这样执行当前用户的cron时，不会发送邮件。  
修改命令：

```bash
sed -i '1 i\MAILTO=""' /var/spool/cron/root
```     

上面这种方法是治标，如果想治本，就把对应cron的中执行脚本的output重定向到文件或/dev/null中。

# Ref
[Linux 中/var/spool/postfix/maildrop目录下堆积大量小文件](http://blog.chinaunix.net/uid-26364035-id-3163574.html)  
[/var/spool/postfix/maildrop/ 中有大量的文件](http://bing2010.blog.51cto.com/1822459/1080074)  
[postfix管理邮件队列](http://51tech.blog.51cto.com/615380/340946)  


