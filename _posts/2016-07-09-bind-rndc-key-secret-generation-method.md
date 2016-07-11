---
layout: post
title: BIND rndc key 生成方法
description: "BIND rndc key 生成方法"
category: Network
avatarimg:
tags: [Network, DNS, BIND]
duoshuo: true
---

# 引言
之前部署配置 bind 的 DNS 主从时，其中在配置文件需要配置 rndc 的 key。那么这个 key 如何生成呢？

# bind rndc key 生成方法

当前只支持 HMAC-MD5 认证算法，secret 是 base-64 编码的，你可以使用一些程序，比如 mmencode 或者 dnssec-keygen(BIND 软件包自带)。  
还有一个 rndc-confgen 命令，用于生成 rndc 的配置文件，我们也可以使用它，如下：

```bash
[root@ns-slave var]# cd /tmp/
[root@ns-slave tmp]# rndc-confgen -r /dev/urandom > rndc.conf
[root@ns-slave tmp]# cat rndc.conf 
# Start of rndc.conf
key "rndc-key" {
	algorithm hmac-md5;
	secret "OoHkJl7vJN7vzS/QWDsbiw==";
};

options {
	default-key "rndc-key";
	default-server 127.0.0.1;
	default-port 953;
};
# End of rndc.conf

# Use with the following in named.conf, adjusting the allow list as needed:
# key "rndc-key" {
# 	algorithm hmac-md5;
# 	secret "OoHkJl7vJN7vzS/QWDsbiw==";
# };
# 
# controls {
# 	inet 127.0.0.1 port 953
# 		allow { 127.0.0.1; } keys { "rndc-key"; };
# };
# End of named.conf
```    


# Ref

[DNS and BIND, Fifth Edition 7.1.2 rndc and controls (BIND 9)](https://book.douban.com/subject/2583522/)  
