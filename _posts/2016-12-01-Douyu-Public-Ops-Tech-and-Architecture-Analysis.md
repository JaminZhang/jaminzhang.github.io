---
layout: post
title: 斗鱼已公开的运维技术和架构分析
description: "斗鱼已公开的运维技术和架构分析"
category: Architecture
avatarimg:
tags: [Douyu, Ops, Architecture]
duoshuo: true
---


# 引言

最近对斗鱼比较关注，所以想知道斗鱼网站应用了哪些运维技术和方案。
所以我从第三方外部看看能获取到哪些斗鱼网站已公开的运维技术和架构。  

最新一个比较全面的斗鱼运维架构分享是在 GITC 2016 北京站的运维专场，以下架构分享文档。
[用户在斗鱼看直播时，斗鱼在看什么](http://www.thegitc.com/ppt2016bj/03%E8%BF%90%E7%BB%B4%E4%B8%93%E5%9C%BA_%E5%90%B4%E7%91%9E%E8%AF%9A_%E6%96%97%E9%B1%BC.pdf)

![斗鱼架构图](http://jaminzhang.github.io/images/Douyu/Douyu-Architecture.png)  


从用户电脑浏览器访问一个网站的过程（还有结合一些公开资料）分析斗鱼网站使用的相关运维技术信息和架构方案。
以下基于[《运维知识体系V1.9-赵班长》](https://www.unixhot.com/page/ops)的分层架构来描述  
（当然有很多信息是一般公司内部不对外开放的，外部是不能获取的，这里也只是列出来）。


# 客户端层


## 1. 浏览器

**包含 Cookie、浏览器缓存协商（Last-Modified、Expires、Etag）、组件分离、前端优化、运维检测工具等内容。**

上述可以通过浏览器开发者工具进行具体查看。

## 2. DNS 域名

**包含浏览器 DNS 缓存、DNS 缓存、自建 DNS 服务器、商业 DNS 产品、智能 DNS 等内容**  

用户使用浏览器访问一个网站，是输入网站域名进行访问的。  
下面我们来看看斗鱼网站的相关域名信息，它的主域名是 douyu.com。

我们使用阿里的 whois 查询服务来查下，
具体信息去以下链接查看 https://whois.aliyun.com/whois/domain/douyu.com

从上面查询到的信息我们可以看到 douyu.com 域名注册商是 GoDaddy。
然后还有一个重要的信息，配置的权威 DNS 服务器为：

* DNS1：NS3.DNSV4.COM
* DNS2：NS4.DNSV4.COM

配置的权威 DNS 服务器是自建还是使用的第三方 DNS 服务？    
我们同样可以使用 whois 查询服务查询一下 dnsv4.com 域名的相关信息，如下：
https://whois.aliyun.com/whois/domain/dnsv4.com  
从里面的信息，我们可以看到，dnsv4.com 的域名是属于中国最大的第三方域名服务商 DNSPod。

扩展：如果作为第三方并不有域名的管理权限，我想知道斗鱼网站的子域名有哪些？如何获取？
之前我写过一篇文章[子域名查找](http://jaminzhang.github.io/network/subdomain-detection/)，使用 wydomain 可以查找到。  


## 3. App 客户端

**包含 HTTP-DNS、打点日志、加密传输、移动推送、各类 SDK（监控 SDK、推流 SDK）等内容**

## 扩展：网站排名

参考 [Alexa douyu.com 排名信息](http://www.alexa.com/siteinfo/douyu.com),国内排名前 50（写此篇文章时）。


# 外部层

## 1. 第三方 CDN 

**包含 GSLB、反向代理缓存、分布式存储、流量调度、配置管理、用户端（各类 API 如：带宽监控、预缓存、缓存刷新）等内容。**  

斗鱼使用 CDN 提供商有哪些？这个在之前，我有写一篇文章分析了。[斗鱼使用的 CDN 服务商分析](http://jaminzhang.github.io/cdn/The-Analysis-of-Douyu-Used-CDN-Provider/)  

* "主线路", cdn: "ws"  网宿
* "备用线路2", cdn: "ws2"  网宿线路 2
* "备用线路3", cdn: "dl"  帝联？
* "备用线路5", cdn: "tct"  腾讯云

## 2. 云计算

包含公有云服务、混合云、运维外包服务、APM（应用性能管理）、第三方安全解决方案（防DDOS、WAF）
等相关内容。

斗鱼在云计算方面暂未查到相关公开资料。



# 网络层

## 1. 互联层

**包含多机房互联（VPN、专线）、异地灾备-->异地多活-->按 SET 部署等内容。**

## 2. 核心层

**包含防火墙、路由器、IPSec VPN、链路负载均衡和高可用 （CCNP 级别）等内容。**

## 3. 汇聚层

**包含三层交换、动态路由（OSPF）、静态路由、EC（端口汇聚）、MSTP+VRRP （CCNP级别）等内容。**

## 4. 接入层

**包含二层交换 （VTP、SPF、Trunk、端口安全）（CCNA 级别）等内容。**

网络层这块一般有专门的网络工程师负责，Linux 运维工程师一般不太涉及深入这方面。  

斗鱼在网络层方面暂未查到相关公开资料。


# 接入层

## 1. 负载均衡高可用

### 四层负载均衡

**包含开源：LVS（IP 负载均衡）+ Keepalived、Haproxy 商业：F5、Netscaler 等内容。**

### 七层负载均衡

**包含反向代理：Haproxy、Nginx、Apache（根据 HTTP 协议支持的属性进行 L7 分发）、A/B Test Gateway、WAF 等内容。**

## 2. 反向代理缓存

**包含ATS、Squid、Varnish、Nginx(缓存分级、预缓存、缓存刷新）等内容。**

斗鱼在接入层方面使用了 CDN、LVS、Nginx、Tomcat、PHP-FPM。


# 应用服务层

## 1. Web 服务层

**包含 HTTP 协议、Web服务器（Apache、Nginx/OpenResty、Tomcat、Resin、Jboss）安全设置、性能优化等内容。**

**HTTP 协议方面**

斗鱼为了保证直播用户的数据安全和隐私安全，全站由 HTTP 协议升级到了 HTTPS。  
（这个信息是从我比较关注一个微信公众号：MacTalk 看到的）

[为什么要全站 HTTPS](http://mp.weixin.qq.com/s?__biz=MjM5ODQ2MDIyMA==&mid=2650712733&idx=1&sn=681e7413eeff0d6189df9c0ef6190e46&chksm=bec064ce89b7edd8427d3eb9d578c314bc209603a5c3e9c0657d6908fc1baae91a9c7c64d9a9&mpshare=1&scene=23&srcid=1108FWOXmSN3tkJlm3K8JLLl#rd)  

<pre>
全站实施 HTTPS 并不是加了一个 S 那么简单，这里面需要投入巨大的技术研发成本、服务器和带宽成本等等。  

HTTPS 会带来更多的网络握手和消耗，如何提升访问性能，如何优化证书链，如何增加高速连接，减少端口之间的跳转等等。
采用了 HTTPS 之后，所有的静态资源都需要支持 HTTPS，如何让 CDN 支持 HTTPS，如何应对 DDoS 的攻击，  
同时，移动客户端也需要与云端进行双向证书认证。
为了解决这些技术问题，斗鱼在前端页面、后端架构、协议特性、加密算法、流量调度、架构和运维、安全等方面都做了大量工作。  
除此之外，他们还需要承担 CA 根节点证书费用、服务器和带宽增加的成本。

实施了 HTTPS 的斗鱼，能为用户带来什么好处呢？  用户可以获得一个干净安全的直播和观看直播的体验。
比如弹幕，弹幕是直播中与主播沟通的工具，是直播不可分割的一部分，深受用户关注和喜爱，
因此非常容易受到恶意攻击行为，发送广告和非法信息。
弹幕是开放给所有用户的公共场所，任何人都可以发言，审核管理工作量巨大且复杂，受到恶意攻击行为后会严重影响到大量用户的体验，
对观看直播造成恶劣的影响。
在 HTTP 时代，我们甚至可以简单的写一段脚本就可以把直播间的所有弹幕信息抓下来，因为数据在网络上是明文传输的。
有了 HTTPS 的保障，无论是客户端还是浏览器，都可以得到更好的用户体验。
</pre>

## 2. 应用服务层

**包含运行环境（PHP Python Java C C++）、性能优化、缓存（OPCache、LocalCache）、Session 存储、代码部署等内容。**


## 3. 业务层

### 3.1 业务实现

**包含API 网关、302 调度、业务模块化（电商网站例子：用户、商品、购物车、结算中心、价格等服务）、微服务等内容。**

### 3.2 SOA 层

**包含 SOA框架（Java Dubbo）、协议（RPC、RESTful）、服务注册、服务发现、框架安全等内容。**

## 4. 分布式层	

### 消息队列

**包含ActiveMQ（成熟）、RabbitMQ（成熟、案例多）、RocketMQ（业务应用）、Kafka（日志传输）、ZeroMQ（快）等内容。**

# 基础服务层

## 1. 业务决策

**包含灰度发布、服务降级、异地灾备、数据分析平台、智能扩容决策树（需要各层支持）等内容。**

## 2. 运维相关

**包含项目管理（Redmine、Jira、知识库、Bugzilla、CodeReview）、工单系统、运维操作平台、监控平台等内容。**

## 3. 应用相关

**包含持续集成、日志收集平台（ELKStack）、自动化部署平台、Job管理（调度）平台、安全扫描平台等内容。**

**ELK 相关**

根据查到的公开资料，斗鱼的搜索服务是基于 ES 的。  
[基于Elasticsearch的斗鱼搜索服务实现](http://conf.elasticsearch.cn/2016/beijing.html#speaker)  
相关内容如下：  

<pre>

主要针对 Elasticsearch 在斗鱼主站、鱼吧、点播系统、移动端等搜索项目中应用及其性能调优，进行演讲介绍，具体内容包含以下几点：

 1.斗鱼主站、鱼吧、点播系统、移动端等不同业务环境下，ES 集群搭建、搜索接口调用、mapping 创建及配置设置。 
 2.斗鱼搜索技术架构，接口采用 Nginx 处理一级缓存以及负责均衡，Tomcat 实现索引同步及搜索接口，以 ES，MySQL，Redis 为基础的数据存储。 
 3.斗鱼搜索服务缓存处理，高并发应对策略。 
 4.由于斗鱼网络科技有限公司的语言异构性，搜索集群如何处理数据同步。 
 5.斗鱼搜索基于 Zabbix + ELK 的监控环境搭建，日志收集。
 6.以及在搜索开发过程中遇到的接口问题、集群环境问题，并发负载问题以及解决方法的分享。
 7.以及未来对搜索服务规划，服务接口化，统一工程分化，Docker 化。

第一个基于 ES 的线上搜索项目是斗鱼鱼吧搜索，该项目类似于斗鱼的论坛，涉及到大量的分词检索，因此，采用了 ES+IK。
上线后，效果明显，且服务器压力，负载均很稳定，便逐渐在其他项目推广开来，斗鱼主站，鱼秀，移动端，点播搜索等等。
再后来不仅搜索服务，部分全站日志收集，实时监控，也采用了 ELK 体系。 

</pre>

## 4. 系统相关

**包含 LDAP、内部 DNS、DHCP、Mail、SMS、GitLab、YUM 仓库、操作审计（xenapp）、堡垒机等内容。**

# 操作系统层

## CPU

**包含 CPU 运行级别、使用率、上下文切换、运行队列、进程调度、系统调用、CPU 管理（进程管理、taskset、Intel VT-X）等内容。**


## 内存

**包含虚拟内存、SWAP 换入换出、内存寻址、内存管理（Buffer Cache、HugePages、ksmd、EPT）等内容。**


## I/O（磁盘）

**包含缺页中断、IOPS（顺序IO、随机IO）、IO 管理（IO 调度算法、virtio）等内容。**


## I/O（网络）

**包含 TCP/IP（三次握手、四次挥手、状态转换、TCP 队列）、IO 模型、Bonding、Bridge、网络管理（iftop、tcpdump）等内容。**

## 内核/Shell

**包含内核定制、内存参数优化、脚本编程（AWK、Sed、Shell、Python、PHP、Perl、Ruby、Lua）等内容。**

# 基础设施层

## IAAS(基础设施即服务)

**包含公有云、私有云（OpenStack/cloudstack+KVM/XEN、oVirt）、混合云等内容。**

## 硬件管理

**包含硬件选型、配件更换、资产录入、系统安装（Cobbler）、标签化、Raid构建、远程控制（KVM、iDrac、ILO、IMM）等内容。**

## IDC 托管

**包含需求分析、IDC选型、网络测试、谈价格、签合同、设备采购（原厂vs渠道）、机柜和机位规划等内容。**

# 测试和开发相关

**包含运维协助：性能测试（TCPCopy、日志转换）、单机监控（nmon）、环境规划（开发、测试、预生产、生产）、CI（持续集成）、自动化部署等内容。**



