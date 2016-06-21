---
layout: post
title: Zabbix 自定义脚本告警配置
description: "Zabbix 自定义脚本告警配置"
category: Monitoring
avatarimg: 
tags: [Zabbix, Alert]
duoshuo: true
---

# 自定义脚本告警原理
自定义告警脚本在 zabbix_server.conf中配置，默认为：
> 
AlertScriptsPath=/usr/lib/zabbix/alertscripts  

Zabbix-Server 在调用脚本的时候，会传递三个变量参数给脚本作为位置参数：$1, $2, $3。
其中：$1 表示收件人，$2 表示主题，$3 表示内容。

# 1 准备好自定义告警脚本

下面我们来写一个测试用的脚本。

```bash
[root@linux-node1 alertscripts]# cat alert_test.sh 
#!/bin/bash

TO=$1
SUBJECT=$2
BODY=$3

echo "Send to: $TO " >> /tmp/test_alert.log
echo "Subject: $SUBJECT" >> /tmp/test_alert.log
echo "Body: $BODY" >> /tmp/test_alert.log

# 以上脚本的日志文件需要让 zabbix 用户读写
touch /tmp/test_alert.log
chown zabbix.zabbix /tmp/test_alert.log

```


自定义脚本可以根据自己的需要配置，比如短信发送的脚本。

# 2 创建配置自定义的告警方式 Media Type

选择 Administration -> Media types，创建自定义告警方式，  
Type 选择 Script，Script name 指定自定义的告警脚本，  
Script parameters 一般设置如下三个：

* {ALERT.SENDTO}
* {ALERT.SUBJECT}
* {ALERT.MESSAGE}

# 3 将自定义的告警方式指定给用户

定位到 Administration -> Users -> Media，添加自定义告警的 Media，  
注意 Media 中 Type 和 Send to 配置，和自定义告警脚本对应。

# 4 配置自定义告警脚本的动作 Action

定位到 Configuration -> Actions，进入告警动作配置界面，创建新的 action。

接下来的 Action/Condition/Operation 根据自定义告警脚本对应配置。


# 自定义告警脚本执行结果
如下，可以看到在日志文件中生成了对应配置的内容

```bash
[root@linux-node1 ~]# tail -n 40 /tmp/test_alert.log 
Body: Trigger: User login number gt 4 on linux-node2.example.com
Trigger status: PROBLEM
Trigger severity: Warning
Trigger URL: 

Item values:

1. Number of logged in users (linux-node2.example.com:system.users.num): 5
2. *UNKNOWN* (*UNKNOWN*:*UNKNOWN*): *UNKNOWN*
3. *UNKNOWN* (*UNKNOWN*:*UNKNOWN*): *UNKNOWN*

Original event ID: 248
Send to: 779432631 
Subject: PROBLEM: User login number gt 4 on linux-node2.example.com
Body: Trigger: User login number gt 4 on linux-node2.example.com
Trigger status: PROBLEM
Trigger severity: Warning
Trigger URL: 

Item values:

1. Number of logged in users (linux-node2.example.com:system.users.num): 5
2. *UNKNOWN* (*UNKNOWN*:*UNKNOWN*): *UNKNOWN*
3. *UNKNOWN* (*UNKNOWN*:*UNKNOWN*): *UNKNOWN*

Original event ID: 248
Send to: 779432631 
Subject: OK: User login number gt 4 on linux-node2.example.com
Body: Trigger: User login number gt 4 on linux-node2.example.com
Trigger status: OK
Trigger severity: Warning
Trigger URL: 

Item values:

1. Number of logged in users (linux-node2.example.com:system.users.num): 4
2. *UNKNOWN* (*UNKNOWN*:*UNKNOWN*): *UNKNOWN*
3. *UNKNOWN* (*UNKNOWN*:*UNKNOWN*): *UNKNOWN*

Original event ID: 248

```    

# Ref
[Custom alertscripts](https://www.zabbix.com/documentation/3.0/manual/config/notifications/media/script)  
[zabbix应用之短信报警](http://qicheng0211.blog.51cto.com/3958621/1551105)  
