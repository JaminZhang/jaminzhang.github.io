---
layout: post
title: Zabbbix 邮件告警配置实例
description: "Zabbbix 邮件告警配置实例"
category: Monitoring
avatarimg: 
tags: [Zabbix, Email]
duoshuo: true
---


# 1 创建 Media
如下图示
![01-Create-Media-Type](https://raw.githubusercontent.com/JaminZhang/jaminzhang.github.io/master/images/Zabbix/Zabbix-Email-Notification-01-Create-Media-Type.png
)  
![02-Config-Media-Type](https://raw.githubusercontent.com/JaminZhang/jaminzhang.github.io/master/images/Zabbix/Zabbix-Email-Notification-02-Config-Media-Type.png)  


# 2 创建并配置用户
如下图示  
重点是配置该用户的 Media Type（告警类型）和 Send to （收件人邮箱）：
![03-Create-user](https://raw.githubusercontent.com/JaminZhang/jaminzhang.github.io/master/images/Zabbix/Zabbix-Email-Notification-03-Create-user.png)  
![04-Config-User-Media](https://raw.githubusercontent.com/JaminZhang/jaminzhang.github.io/master/images/Zabbix/Zabbix-Email-Notification-04-Config-User-Media.png) 


# 3 创建 Actions
如下图示
重点是配置 Action Operations，具体说明参考相关资料
![05-Create-action](https://raw.githubusercontent.com/JaminZhang/jaminzhang.github.io/master/images/Zabbix/Zabbix-Email-Notification-05-Create-action.png) 
![06-Action-Operations](https://raw.githubusercontent.com/JaminZhang/jaminzhang.github.io/master/images/Zabbix/Zabbix-Email-Notification-06-Action-Operations.png) 
![07-Action-Enabled](https://raw.githubusercontent.com/JaminZhang/jaminzhang.github.io/master/images/Zabbix/Zabbix-Email-Notification-07-Action-Enabled.png) 


# 4 告警邮件接收结果
如下图示  
在触发 Trigger 后进行 Action，故障产生时，发送告警通知邮件，故障恢复后，发送 Recovery OK 通知邮件  
![08-Received-email](https://raw.githubusercontent.com/JaminZhang/jaminzhang.github.io/master/images/Zabbix/Zabbix-Email-Notification-08-Received-email.png)  
![09-Received-email](https://raw.githubusercontent.com/JaminZhang/jaminzhang.github.io/master/images/Zabbix/Zabbix-Email-Notification-09-Received-email.png)  


# Ref
[zabbix action报警配置（36）](http://www.ttlsa.com/zabbix/zabbix-actions/)   
