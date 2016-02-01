---
layout: post
title: ansilbe命令选项
description: "ansilbe命令选项"
category: Linux
avatarimg:
tags: [Ansible]
duoshuo: true
---


# 引言
一同事需要批量对服务器初始化，没有用过ansible，问我，我用过几次，相关选项记得不是很清楚，  
于是重新学习记录下。

# 命令选项说明
最常用的一些命令如下：
> 
ansible -i test.txt all -m shell -k -a "ifconfig"

上面各个选项都能通过man查到说明。

<pre>

-i PATH, --inventory=PATH
    The PATH to the inventory hosts file, which defaults to /etc/ansible/hosts.
-m NAME, --module-name=NAME
    Execute the module called NAME.
-a 'ARGUMENTS', --args='ARGUMENTS'
    The ARGUMENTS to pass to the module.
-k, --ask-pass
    Prompt for the SSH password instead of assuming key-based authentication with ssh-agent.

</pre>

-i指定主机列表文件，一般里面存放的是要批量操作的主机IP列表。指定了inventory文件，当前目录下的hosts文件，不指定则使用默认位置。
all 针对hosts定义的所有主机执行，可以指定组名或者模式。  
-m指定要执行的模块名称，上面的例子是Shell模块，是常用的模块。  
-a指定传递给模块的参数，上面的例子是传递给Shell模块的要执行的具体Shell命令。  
-k指定SSH密码认证时的密码提示。  

# Ref
man ansible  
[Ansible quick start](http://tuxknight-notes.readthedocs.org/en/latest/ansible/install.html)  




