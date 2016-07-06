---
layout: post
title: SaltStack 系统性学习 03 - 配置管理
description: "SaltStack 系统性学习 03 - 配置管理"
category: SaltStack
avatarimg:
tags: [SaltStack]
duoshuo: true
---

# Salt State 组件

## 为什么要引入 State

<pre>
Remote execution is a big time saver, but it has some shortcomings. 
Most tasks you perform are a combination of many commands, tests, and operations, each with their own nuances and points-of-failure.
Often an attempt is made to combine all of these steps into a central shell script, but these quickly get unwieldy and 
introduce their own headaches.

To solve this, SaltStack configuration management lets you create a re-usable configuration template, called a state, 
that describes everything required to put a system component or application into a known configuration.
</pre>

## State 使用 YAML ，所以易读

States are described using YAML, and are simple to create and read.

*YAML 简介*

YAML是"YAML Ain't a Markup Language"（YAML不是一种标记语言）的递归缩写。它是类似于标准通用标记语言的子集XML的数据描述语言，语法比XML简单很多。

<pre>
Salt uses a simple language, called YAML, to describe configurations. This is what you need to know:

YAML uses a fixed indentation scheme to represent relationships between data layers. Salt requires that the indentation 
for each level consists of exactly two spaces. Do not use tabs.

A dash represents an item in a list.

Key value pairs are represented by key: value
</pre>

以上说了 YAML 的语法，有 3 个规则：

1. 缩进（代表层级关系，2个空格，并且不能使用 TAB 键，整个 SaltStack 里面都不能用 TAB 键）
2. 冒号 ：
	1. 跟缩进一起代表一个数据层级（以冒号结尾不用空格）；
	2. 分隔键值对 [key: value] ，支持嵌套，冒号后面必须有一个空格
3. 短横线 -（表示一个列表中的一个项目，- 后面必须有空格）

Salt 的配置文件是 YAML 语法。


# 编写 STATE 状态文件

## 1. 配置 Master file_roots

Salt 运行了一个使用 zeromq 编写的轻量级文件服务器，用于分发文件到 minions。这个文件服务器内建到 master 进程，它不需要一个专用的端口。

这个文件服务器工作在传递给 master 的环境上，每个环境可以有多个根目录。
一个 base 环境是必需的，里面放置 top file.

例子：

```bash
# Example:
# file_roots:					# 配置项
#   base:						# 配置 base 环境
#     - /srv/salt/				# 可以写多个，是一个列表，base 环境的根路径
#   dev:
#     - /srv/salt/dev/services
#     - /srv/salt/dev/states
#   prod:
#     - /srv/salt/prod/services
#     - /srv/salt/prod/states

file_roots:
  base:
    - /srv/salt

# 配置完成 master 的 file_roots 后，要重启 master

systemctl restart salt-master	
	
```    

## 2. 编写一个 STATE 状态文件

```bash
# 创建 base 环境的目录
mkdir /srv/salt -p
cd /srv/salt
mkdir web
cd web

# 编写一个描述 apache 状态的状态文件
cat >> apache.sls << EOF
apache-install:     # 状态声明ID，每一个 ID 就是一个配置项
  pkg.installed:    # 这里面的模块可以是内置的状态模块，也可以是自定义的状态模块
    - names:
        - httpd
        - httpd-devel

apache-service:
  service.running:
    - name: httpd
    - enable: True
EOF


# 一个 Salt 状态可以使用单个的 SLS 文件（一个 SLS 文件就定义了一个状态），或者使用一个文件夹。后者更加灵活方便。

# 上面例子中 apache-install 是定义的状态声明 ID，pkg 是一个状态模块，模块分为执行模块和状态模块，installed 是模块中定义的函数方法

# Salt 有很多的模块，它们都放在 /usr/lib/python2.7/site-packages/salt/modules 下，而 pkg.py 是放在 /usr/lib/python2.7/site-packages/salt/states 目录下的，所以说它是一个状态模块
```   

## 3. 执行状态模块

salt '*' state.sls web.apache

>
state 是一个模块（/usr/lib/python2.7/site-packages/salt/modules/state.py），sls 是它的一个方法，它的作用就是 Execute the states in one or more SLS files，这些状态文件是放在环境下的，并且这些状态文件里面会调用 state 的状态模块（/usr/lib/python2.7/site-packages/salt/states）。

>
/var/cache/salt/minion 是一个很重要的目录，一般 master 把文件发给 minion 并放在这个目录下, minion从上往下加载



## 4. 通过 top.sls 来有选择的执行状态文件

top 文件也是 sls 结尾，也是 YAML 格式。它放在 base 环境下。

```bash
# The state system uses a "top" file to tell the minions what environment to
# use and what modules to use. The state_top file is defined relative to the
# root of the base environment as defined in "File Server settings" below.
# state_top: top.sls

# top file 的实质就是告知状态应用到哪些 minion 上（告诉 minion 使用什么环境和什么模块）。

cat > top.sls <<EOF
base:
  'linux-node1.example.com':
    - web.apache
  'linux-node2.example.com':
    - web.apache
EOF


# 执行高级状态 highstate

salt '*' state.highstate

生产中不建议用 * ，然后要先在测试模式运行，salt '*' state.highstate test=True
