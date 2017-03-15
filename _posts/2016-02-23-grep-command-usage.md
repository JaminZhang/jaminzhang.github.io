---
layout: post
title: grep 命令用法总结
description: "grep 命令用法总结"
category: Linux
avatarimg:
tags: [grep, sed]
duoshuo: true
---

# 实例 1

删除某目录下所有文件含有 test 字符串的行

> 
grep -r -l "test"  * | xargs sed -i "/test/d"

上面使用 grep 递归搜索包含 test 字符串的文件名，然后传递给 sed 做删除操作

```bash

-r, --recursive # 递归读取目录下的所有文件
Read all files under each directory, recursively, 
following symbolic links only if they are on the command line.
This is equivalent to the -d recurse option.

-l, --files-with-matches  # 打印匹配的文件名
Suppress normal output; instead print the name of each input file from which 
output would normally have been printed.
The scanning will stop on the first match.  (-l is specified by POSIX.)

```    


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
[root@xxx xxx]# grep -r -l --exclude-dir="test" "\/etc\/init.d\/zabbix-agent restart"  * | \
xargs sed -i "/\/etc\/init.d\/zabbix-agent restart/r /tmp/zabbix-api.txt"
```    

# 实例 3

统计一个文件中包含特定字符串的个数。

```bash

# 统计 test.txt 文件中 jamin 字符串的个数
[root@VM_15_187_centos ~]# grep --color=auto jamin test.txt
jamin jamin
txt jamin
abcd jamin
[root@VM_15_187_centos ~]# grep  -o jamin test.txt 
jamin
jamin
jamin
jamin
[root@VM_15_187_centos ~]# grep -o jamin test.txt  | wc -l
4

-o, --only-matching # 只打印一个匹配行的匹配部分
Print only the matched (non-empty) parts of a matching line, with each such part on a separate output line.

```    

# Ref
man grep
