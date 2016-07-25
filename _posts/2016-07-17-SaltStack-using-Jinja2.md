---
layout: post
title: SaltStack 中使用 Jinja2 模板
description: "SaltStack 中使用 Jinja2 模板"
category: SaltStack
avatarimg:
tags: [SaltStack, Jinja2]
duoshuo: true
---

# 什么是 Jinja2

<pre>
Jinja2 是一个 Python 的功能齐全的模板引擎。
它有完整的 unicode 支持，一个可选 的集成沙箱执行环境，被广泛使用，以 BSD 许可证授权。

Jinja2 是一个现代的，设计者友好的，仿照 Django 模板的 Python 模板语言。 
它速度快，被广泛使用，并且提供了可选的沙箱模板执行环境保证安全。

特性:

沙箱中执行
强大的 HTML 自动转义系统保护系统免受 XSS
模板继承
及时编译最优的 python 代码
可选提前编译模板的时间
易于调试。异常的行数直接指向模板中的对应行。
可配置的语法

</pre>

# Salt 使用 Jinja2 模板

<pre>
SaltStack 是使用的 YAML 语言来将 sls 文件解释成它自己可以识别的内容，Jinja 是一种基于 PYTHON 的模板引擎，
在 SLS 文件里可以直接使用 jinja 模板来做一些操作。
比如当我们需要对多台服务器做一些 apache 服务配置时，由于每台服务器信息不一样（比如ip不同），
如果为每台服务器去创建SLS文件就不太合理，而通过jinja模板则可以用生成变量→读取变量的方式来为每个服务器设置应有的信息。
</pre>


## 1 使用 Jinja2 模板的三步

1.告诉 file 模块，要使用 jinja  
2.列出参数列表  

```bash
apache-config:
  file.managed:
    - name: /etc/httpd/conf/httpd.conf
    - source: salt://lamp/files/httpd.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja    # 1.增加这行表示开启模板
    - defaults:          # 2.下面设定变量的值
      PORT: 88
```   
3.文件中模板变量引用  


**模板里面支持 salt/grains/pillar进行变量赋值**
下面分别进行举例  


## 2 Jinja2 模板的基本使用

1.首先将 source 文件中需要引用变量的内容改为{{ 变量名 }}，如修改 apache 配置文件中的端口信息:  

将 Listen 80 修改成 Listen {{ PORT }}  

2.对 SLS 文件进行编辑以定义模板并且给变量传值，在第一步中定义了几个变量就必须给几个变量传值    
配置 apache-config 的状态如下：  

```bash
apache-config:
  file.managed:
    - name: /etc/httpd/conf/httpd.conf
    - source: salt://lamp/files/httpd.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja    # 增加这行表示开启模板
    - defaults:          # 下面设定变量的值
      PORT: 88
```    
3.执行 state.sls    
输出如下：

```bash
----------
          ID: apache-config
    Function: file.managed
        Name: /etc/httpd/conf/httpd.conf
      Result: None
     Comment: The file /etc/httpd/conf/httpd.conf is set to be changed
     Started: 16:23:32.575140
    Duration: 80.33 ms
     Changes:   
              ----------
              diff:
                  --- 
                  +++ 
                  @@ -39,7 +39,7 @@
                   # prevent Apache from glomming onto all bound IP addresses.
                   #
                   #Listen 12.34.56.78:80
                  -Listen 80
                  +Listen 88
                   
                   #
                   # Dynamic Shared Object (DSO) Support
----------
```    

## 3 Jinja2 模板的高级使用

在基本使用中由于修改的是端口，端口信息一般是固定的，如果想要修改的信息是每个 minion 自身的 IP 就没办法设置一个通用的信息了，这个时候需要通过其他方法来获取 minion 相关信息，这里可以使用 Grains 、Pillar 和执行模块三个方法来获取。

### 3.1 用 Grains 举例-设置IP 

增加的配置内容如下：

```bash
    - template: jinja
    - defaults:
      PORT: 88
      HOST: {{ grains['fqdn_ip4'][0] }}
      # [fqdn_ip4]代表的是 IP，该信息需要先执行 salt '*' grains.items 查询，由于 grains 
	  # 查询输出的是列表，会有多个值，需要加上[0]代表取第一个值
```    

同样需要修改 httpd.conf 文件引用上面定义的模板变量，如下：
>
Listen {{ HOST }}:{{ PORT }}


执行 state.sls  
输出如下：

```bash
----------
          ID: apache-config
    Function: file.managed
        Name: /etc/httpd/conf/httpd.conf
      Result: None
     Comment: The file /etc/httpd/conf/httpd.conf is set to be changed
     Started: 16:38:42.643145
    Duration: 37.981 ms
     Changes:   
              ----------
              diff:
                  --- 
                  +++ 
                  @@ -39,7 +39,7 @@
                   # prevent Apache from glomming onto all bound IP addresses.
                   #
                   #Listen 12.34.56.78:80
                  -Listen 88
                  +Listen 192.168.56.12:88
                   
                   #
                   # Dynamic Shared Object (DSO) Support
----------
```    

### 3.2 使用 Salt 远程执行模块举例-获取网卡 MAC 地址

以下为演示（远程命令直接写在 httpd.conf 中，为注释状态）
>
Listen {{ HOST }}:{{ PORT }}  
# The MAC is: {{ salt['netwrok.hw_addr']('eth0') }}

执行 state.sls 后的输出如下(截取部分)：

```bash
----------
          ID: apache-config
    Function: file.managed
        Name: /etc/httpd/conf/httpd.conf
      Result: None
     Comment: The file /etc/httpd/conf/httpd.conf is set to be changed
     Started: 16:47:28.887669
    Duration: 51.994 ms
     Changes:   
              ----------
              diff:
                  --- 
                  +++ 
                  @@ -39,7 +39,8 @@
                   # prevent Apache from glomming onto all bound IP addresses.
                   #
                   #Listen 12.34.56.78:80
                  -Listen 88
                  +Listen 192.168.56.12:88
                  +# The MAC is: 00:0c:29:bf:c0:16    # 可以看到，取到了 MAC 地址
                   
                   #
                   # Dynamic Shared Object (DSO) Support
----------

```    

### 3.3 使用 Phillar - 举例

一般用于配置用户名密码的时候  
以下为演示（ Phillar 配置加到 httpd.conf 中，为注释状态）  
> 
# Pillar test: User: salt Password: {{ pillar['apache'] }}

pillar['apache'] 已在 Salt Master 上配置好，可以先在 Master 上看下：

```bash
[root@linux-node1 files]# salt '*node2*' pillar.items apache
linux-node2.example.com:
    ----------
    apache:
        httpd
```    

执行 state.highstate 后的输出如下(截取部分)：

```bash
----------
          ID: apache-config
    Function: file.managed
        Name: /etc/httpd/conf/httpd.conf
      Result: None
     Comment: The file /etc/httpd/conf/httpd.conf is set to be changed
     Started: 18:24:41.837882
    Duration: 107.177 ms
     Changes:   
              ----------
              diff:
                  --- 
                  +++ 
                  @@ -39,7 +39,9 @@
                   # prevent Apache from glomming onto all bound IP addresses.
                   #
                   #Listen 12.34.56.78:80
                  -Listen 88
                  +Listen 192.168.56.12:88
                  +# The MAC is: 00:0c:29:bf:c0:16
                  +# Pillar test: User: salt Password: httpd    # 此处说明已经成功设置了 pillar item
                   
                   #
                   # Dynamic Shared Object (DSO) Support
----------
```    

Pillar {{ pillar['apache'] }} > 上面是写在模板文件中，还有另外一种方法，Grains/Pillar 等也可以写在 SLS 文件里面

# Ref
[Jinja2 文档](http://docs.jinkan.org/docs/jinja2/index.html)
[SaltStack配置管理工具jinja2模板的使用](http://www.linuxe.cn/post-247.html)  
