---
layout: post
title: rsync hosts allow配置主机名
description: "rsync hosts allow配置主机名"
category: Linux
avatarimg:
tags: [rsync]
duoshuo: true
---

# 引言
今天，数据库备份机迁移要更换IP，我们的数据库备份机制是首先是本地定期备份，然后每台服务器开启rsync daemon进程，指定几台备份服务器访问，备份服务器每天定时从服务器的本地备份目录拉取数据库备份。  
如果要更换备份机的IP，那么其他服务器上的rsyncd.conf配置文件就需要修改hosts allow的IP参数，批量修改和重启还是很简单的。但当时，我多想了一下，IP指标识备份机还是比较繁琐，hosts allow是否可以指定主机名或域名？这样可以避免备份机IP改变的情况。

# rsync的hosts allow参数
通过man可得知如下hosts allow支持的形式：

<pre>

hosts allow
This parameter allows you to specify a list of patterns that are matched against a connecting clients hostname and IP address. If none of the patterns match then the connection is rejected.
Each pattern can be in one of five forms:

a dotted decimal IPv4 address of the form a.b.c.d, or an IPv6 address of the form a:b:c::d:e:f. In this case the incoming machine's IP address must match exactly.
an address/mask in the form ipaddr/n where ipaddr is the IP address and n is the number of one bits in the netmask. All IP addresses which match the masked IP address will be allowed in.
an address/mask in the form ipaddr/maskaddr where ipaddr is the IP address and maskaddr is the netmask in dotted decimal notation for IPv4, or similar for IPv6, e.g. ffff:ffff:ffff:ffff:: instead of /64. All IP addresses which match the masked IP address will be allowed in.
a hostname pattern using wildcards. If the hostname of the connecting IP (as determined by a reverse lookup) matches the wildcarded name (using the same rules as normal unix filename matching), the client is allowed in. This only works if "reverse lookup" is enabled (the default).
a hostname. A plain hostname is matched against the reverse DNS of the connecting IP (if "reverse lookup" is enabled), and/or the IP of the given hostname is matched against the connecting IP (if "forward lookup" is enabled, as it is by default). Any match will be allowed in.

</pre>

最后2种形式就是支持主机名的。

# 验证

<pre>

[dbbak]
path = /data/backup
ignore errors = yes
read only = true
list = false
hosts allow = sfo1.jaminzhang.me
hosts deny = 0.0.0.0/0
auth users = backuper
secrets file = /etc/rsyncd.pass

2016/01/21 21:54:22 [9595] auth failed on module dbbak from sfo1.jaminzhang.me (104.236.187.xx): missing secret for user "backuper"
2016/01/21 21:55:39 [9596] connect from sfo1.jaminzhang.me (104.236.187.xx)
2016/01/21 21:55:39 [9596] auth failed on module dbbak from sfo1.jaminzhang.me (104.236.187.xx): missing secret for user "backuper"
2016/01/21 21:56:59 [9569] rsync error: received SIGINT, SIGTERM, or SIGHUP (code 20) at rsync.c(546) [receiver=3.0.6]
2016/01/21 21:57:05 [9603] rsyncd version 3.0.6 starting, listening on port 59873
2016/01/21 21:57:14 [9610] connect from sfo1.jaminzhang.me (104.236.187.xx)
2016/01/21 21:57:15 [9610] auth failed on module dbbak from sfo1.jaminzhang.me (104.236.187.xx): password mismatch
2016/01/21 21:57:38 [9611] connect from sfo1.jaminzhang.me (104.236.187.xx)
2016/01/21 21:57:39 [9611] rsync on dbbak/test from backuper@sfo1.jaminzhang.me (104.236.187.xx)
2016/01/21 21:57:40 [9611] building file list
2016/01/21 21:58:32 [9611] sent 4813634 bytes  received 102 bytes  total size 4812805

</pre>

上面rsyncd.conf配置文件中的hosts allow参数是用的主机名的形式。  
验证过程中出现了小问题，通过日志可以看出来。  
首先， missing secret for user "backuper"，是因为rsync daemon端中的secrets file中内容规则应该是auth-user:passwrod的形式，再就是password mismatch，是因为rsync client端的pasword file中内容规则应该是password形式，rsync很久没有手动配置过，忘记了。  
从这里也可以看出日志文件对于排错非常重要。

# Ref
[rsyncd.conf(5)](http://rsync.samba.org/ftp/rsync/rsyncd.conf.html)  
