---
layout: post
title: Zabbix Agent监听端口相关问题
description: "Zabbix Agent监听端口相关问题"
category: Zabbix
avatarimg: 
tags: [Zabbix, Telnet]
duoshuo: true
---

# 引言
在CMDB中查看新配置的机器的监控，发现没有，正常应该是自动添加上的。  
于是叫运维开发一起看下。

# telnet测试Zabbix Agent端口连通性

```bash
telnet 101.198.x.x 10050
Trying 101.198.x.x...
Connected to 101.198.x.x.
Escape character is '^]'.
Connection closed by foreign host.
```    

从上面的telnet命令输出可以看出，Zabbix Agent端口是开启的，因为已经“Connected”。
但最后的“Connection closed by foreign host.”说明Zabbix Agent主动关闭了此次连接。


执行上面的命令后，echo $?, $?为1。

运维开发这样说：
>
其他我不知道，代码里面，只判断退出码为1  ，具体取数据那是zabbix的事  
问题很清楚，就是因为telnet退出码为1  
其他的不需要考虑的  

这样看来，运维开发的自动加Zabbix的程序是这样的判断逻辑。
这个判断逻辑有问题，上面的输出说明Zabbix Agent监听端口是正常的，最后主动关闭连接$?返回为1，这是Zabbix Agent的一个处理机制。
在Zabbix Agent的配置文件中有个Server参数，只有在里面的Zabbix Server telnet Zabbix Agent 才不会被Zabbix Agent主动关闭返回1。

至此，原因就比较清楚了：运维开发的自动加Zabbix的程序判断Zabbix Agent是否存活的机制有问题。

运维开发修改程序后，就正常自动加上监控了。

# Ref
[telnet - “Connection closed by foreign host”](http://unix.stackexchange.com/questions/213364/telnet-connection-closed-by-foreign-host)  
[Zabbix Agent配置文件说明](http://jaminzhang.github.io/linux/zabbix-agentd-config/)  







