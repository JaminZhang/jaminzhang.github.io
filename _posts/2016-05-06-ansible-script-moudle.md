---
layout: post
title: Ansilbe script 模块
description: "Ansilbe script 模块"
category: Ops-Automation
avatarimg:
tags: [Ansible]
duoshuo: true
---

# 引言

研发需要在某业务的所有服务器上执行一个 awk 命令，如下（看起来较复杂）：

```bash

grep recharge /data/gameinfo/s*/* |awk 'BEGIN{FS="&|="} {if($14 > 1462258800 && $14 < 1462348800){a[$18]+=$24}} END{for(i in a){print i, a[i]}}'

```    

使用 Ansible 的 shell 模块执行上述命令，会报符号错误，里面特殊符号太多了。
所以考虑 Ansible 是否可以将一个 Shell 脚本传送到远端执行，查了下，script 模块就是做这个的。

# Ansible script 模块

使用 script 模块可以在本地写一个脚本，然后在远程服务器上执行：  

```bash

ansible myservers -m script -a "/opt/app/target.sh"

```    

# Ref
[使用 Ansible 批量管理远程服务器](http://www.cnblogs.com/me115/p/4529944.html)  
[Commands Modules](http://docs.ansible.com/ansible/list_of_commands_modules.html)  

