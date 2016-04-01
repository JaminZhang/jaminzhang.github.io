---
layout: post
title: Murder下载测试
description: "Murder下载测试"
category: Linux
avatarimg:
tags: [Murder, P2P, BT]
duoshuo: true
---

# 引言
在了解了Murder的用途和简要用法后，我接下来在测试环境下进行测试。

# 0.准备工作
各个节点部署murder的软件包。
https://github.com/lg/murder/tree/master/dist

这里我们不用Murder自带的Capistrano配置管理工具，可以根据自己业务现有配管工具结合murder。

>
考虑到以后大量机器的情况，murder程序包需要安装部署到服务器上，脚本安装？PY文件打包成rpm包通过yum来安装？通过配管工具临时批量分发？这些都是需要思考的问题。现在测试阶段，使用脚本命令部署。

# 1、启动Tracker服务器
> 
python /usr/local/murder/dist/murder_tracker.py > /var/log/murder_tracker.log 2>&1 &

> 
log文件之后需要配置logrotate。

# 2、在Seeder服务器上创建种子
手动命令：
> 
deploy_file=/data/upload/deploy.test.tar.gz
python /usr/local/murder/dist/murder_make_torrent.py ${deploy_file} ${tracker_IP}:8998 ${deploy_file}.torrent

# 3、启动Seeder服务器
> 
python /usr/local/murder/dist/murder_client.py seed ${deploy_file}.torrent ${deploy_file} 127.0.0.1

# 4、下载节点peer执行下载

首先可通过批量分发工具将Seeder上生成的种子文件分发到各Peer节点上，然后在各Peer节点上执行下载：
> 
看了一个别人的用法，可以在执行下载时指定torrent文件时使用HTTP URL的形式。

<pre> 
download_file=/data/download/deploy.test.tar.gz
IP=`curl http://www.5ding.com/dnsip/dnsip`
python /usr/local/murder/dist/murder_client.py peer ${download_file}.torrent ${download_file} $IP
</pre>

# Murder测试使用过程中的疑问
## 1、peer节点进行下载时使用的是peer模式，只有下载，有没有上传？
从我们使用BT软件的经验和常识到判断，BT协议的特点就是节点需要上传文件才提升文件下载速度的。所以应该是有上传的。  
我在测试过程中观察peer节点下载完成文件后，会保持一段时间的端口开启（ 默认为30s，默认时间后，下载进程就会退出，我们可以根据自己的情况修改这个默认时间，配置参数在dist/murder_client.py中的 t = threading.Timer(30.0, ok_close_now) ），从这里，我们可以推断这是提供上传的。peer模式并不像我之前曾理解的那样只做纯粹的下载，  
它在下载完成后会有一段时间的seeding。

## 2、peer节点下载文件完成后，会进行文件完整性的校验吗？如果下载文件出错，会有报错吗？
这得从BT软件的下载原理来看了，
> 
下载时，BT客户端首先解析.torrent文件得到Tracker地址，然后连接Tracker服务器。Tracker服务器回应下载者的请求，提供给下载者其他下载者（包括发布者）的IP。下载者再连接其他下载者，根据.torrent文件，两者分别告知对方自己已经有的块，然后交换彼此的数据。此时不需要其他服务器参与，分散了单个线路上的数据流量，因此减轻了服务器负担。
下载者每得到一个块，需要算出下载块的Hash验证码与.torrent文件中的对比，如果一样则说明块正确，不一样则需要重新下载这个块。这种规定是为了解决下载内容准确性的问题。

从上面BT下载原理可以看出，下载过程中是有下载块的检验的。所以BT软件应该要保证下载文件的完整性。
在Murder中，[dist/BitTornado/download_bt1.py文件中](https://github.com/lg/murder/blob/master/dist/BitTornado/download_bt1.py)
self.errorfunc('piece %d failed hash check, re-downloading it' % index)，这里应该就是在下载块hash检查错误时，重新下载的提示。

所以，现在我们应该没有必要额外再对BT下载完成后的文件进行完整性校验。

# Ref
[Twitter - Murder Bittorrent Deploy System](https://vimeo.com/11280885)  
[BT下载](http://baike.baidu.com/view/19229.htm)  


