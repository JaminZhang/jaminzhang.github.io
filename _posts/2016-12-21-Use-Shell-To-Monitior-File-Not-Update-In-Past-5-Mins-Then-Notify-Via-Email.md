---
layout: post
title: Shell 实现对 5 分钟内没有更新的文件进行邮件通知
description: "Shell 实现对 5 分钟内没有更新的文件进行邮件通知"
category: Shell
avatarimg:
tags: [Linux, Shell, Bash, date, find, SendMail]
duoshuo: true
---

 
# 引言
 
说说最近的几次面试遇到的 Shell 脚本相关问题，接上一篇，个人现场思路不太快速，于是回来重新编写下。
这次一个没写出具体 Shell 代码的题目是：  

>
编写 Shell 脚本，如果文件 /root/test.log 在 5 分钟内没有更新，则发送邮件给一个指定邮箱地址。


# 思路

获取文件修改时间，然后和当前时间比较，如果大于 5 分钟，就发送邮件。

# 实现

## 思路 1

```bash
#!/bin/bash

Current_Timestamp=`date +%s`		# 获取当前时间的 Unix 时间戳
File_Modified_Time=`stat test.log | grep "Modify" | cut -d"." -f1 | cut -d":" -f2-`	# 获取文件修改时间
File_Modified_Timestamp=`date -d "${File_Modified_Time}" +%s`	# 获取文件修改时间的 Unix 时间戳


Difftime=`expr ${Current_Timestamp} - ${File_Modified_Timestamp}`	# 获取当前时间和文件修改时间的 Unix 时间戳时间差

if [ $Difftime -gt 300 ]		# 如果时间差大于 300s，说明文件修改时间是在 5 分钟前，也就是最近 5 分钟文件没有更新，如果满足条件就触发以下的邮件发送动作
then
    echo "File not update in past 5 mins." | mail -s "File not update!" hdlover09@qq.com
fi
```    

>
上面的脚本理想情况是实时不停的执行，但在 Linux 下，一般 Shell 脚本定时执行 crontab 最小精确到分钟级别，不过这种级别也应该够了。


## 思路 2

不像思路 1 那么直接，而是巧妙间接使用 find 命令来找出 5 分钟前没更新过的文件。
具体如下：  

```bash

#!/bin/bash

File_Update_Flag=`cd /root && find -iname "test.log" -type f -mmin +5 | wc -l`		# 使用 find 命令查找 5 分钟前文件更新的文件并且文件名是 test.log

if [ ${File_Update_Flag} -eq 1 ]			# 如果找到了这个文件，就就触发以下的邮件发送动作
then
    echo "File not update in past 5 mins." | mail -s "File not update!" hdlover09@qq.com
fi

```    

>
上面的脚本理想情况是实时不停的执行，但在 Linux 下，一般 Shell 脚本定时执行 crontab 最小精确到分钟级别，不过这种级别也应该够了。


# Ref

[Linux命令date日期时间和Unix时间戳互转](http://www.opstool.com/article/224)  
[linux中的文件查找方法](http://beckup.blog.51cto.com/6135002/1152114)  
[Fix: Send-Mail: Warning: Inet_protocols: IPv6 Support Is Disabled](http://www.ttlsa.com/linux/fix-send-mail-warning-inet/)  
