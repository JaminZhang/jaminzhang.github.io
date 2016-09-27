---
layout: post
title: grep 命令用法总结
description: "grep 命令用法总结"
category: Linux
avatarimg:
tags: [bash, grep, sed]
duoshuo: true
---

# 实例 1

删除某目录下所有文件含有 test 字符串的行

> 
grep -r -l "test"  * | xargs sed -i "/test/d"

上面使用 grep 递归搜索包含 test 字符串的文件名，然后传递给 sed 做删除操作

# 实例 2

在某目录下（包含子目录，但排除 test 目录）的所有脚本中 “/etc/init.d/zabbix-agent restart” 这行的后面添加上如下几行：

```bash
sleep 5
IP_ADDR=`curl -s http://xxx.xx/getip.php`
curl -H "X-Auth-Token:${token}" http://xxx.xx:8332/api/monitor -d ip=${IP_ADDR}
```    

>
以上需求来自实际生产，实际目的是将一个目录下（排除部分目录）所有的系统初始化脚本添加上安装 Zabbix Agent 后，通知自动添加 Zabbix 监控的 API。

实现方法：

```bash
[root@xxx xx]# cat /tmp/zabbix-api.txt  # 将要添加的多行内容写在一个文件中
sleep 5
IP_ADDR=`curl -s http://xxx.xx/getip.php`
curl -H "X-Auth-Token:${token}" http://xxx.xx:8332/api/monitor -d ip=${IP_ADDR}

# grep 结合 sed 
[root@xxx xxx]# grep -r -l --exclude-dir="test" "\/etc\/init.d\/zabbix-agent restart"  * | xargs sed -i "/\/etc\/init.d\/zabbix-agent restart/r /tmp/zabbix-api.txt"
```    

