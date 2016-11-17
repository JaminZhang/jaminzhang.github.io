---
layout: post
title: CGI/FastCGI/PHP-CGI/PHP-FPM 概念理解
description: "CGI/FastCGI/PHP-CGI/PHP-FPM 概念理解"
category: Web
avatarimg:
tags: [CGI, FastCGI, PHP-CGI, PHP-FPM]
duoshuo: true
---

# 引言

CGI/FastCGI/PHP-CGI/PHP-FPM 有时看到这些术语时，对它们的概念容易混淆。  
现在我们来系统学习理解下。

# CGI

CGI 全称是“公共网关接口”(Common Gateway Interface)，HTTP 服务器与你的或其它机器上的程序进行“交谈”的一种工具，其程序须运行在网络服务器上。  

CGI 可以用任何一种语言编写，只要这种语言具有标准输入、输出和环境变量。如 PHP, Perl, Tcl 等。  

# FastCGI

FastCGI 像是一个常驻(long-live)型的 CGI，它可以一直执行着，只要激活后，不会每次都要花费时间去 fork 一次（这是 CGI 最为人诟病的 fork-and-execute 模式）。  
它还支持分布式的运算，即 FastCGI 程序可以在网站服务器以外的主机上执行并且接受来自其它网站服务器来的请求。  

FastCGI 是语言无关的、可伸缩架构的 CGI 开放扩展，其主要行为是将 CGI 解释器进程保持在内存中并因此获得较高的性能。  
众所周知，CGI 解释器的反复加载是 CGI 性能低下的主要原因，如果 CGI 解释器保持在内存中并接受 FastCGI 进程管理器调度，则可以提供良好的性能、伸缩性、Fail-Over 特性等等。  

## FastCGI 特点

1. FastCGI 具有语言无关性。
2. FastCGI 在进程中的应用程序，独立于核心 Web 服务器运行，提供了一个比 API 更安全的环境。API 把应用程序的代码与核心的 Web 服务器链接在一起，这意味着在一个错误的 API 的应用程序可能会损坏其他应用程序或核心服务器。恶意的 API 的应用程序代码甚至可以窃取另一个应用程序或核心服务器的密钥。
3. FastCGI 技术目前支持语言有：C/C++、Java、Perl、Tcl、Python、SmallTalk、Ruby 等。相关模块在 Apache, IIS, Lighttpd 等流行的服务器上也是可用的。
4. FastCGI 不依赖于任何 Web 服务器的内部架构，因此即使服务器技术的变化, FastCGI 依然稳定不变。

## FastCGI 的工作原理

1. Web Server 启动时载入 FastCGI 进程管理器（IIS ISAPI 或 Apache Module)
2. FastCGI 进程管理器自身初始化，启动多个 CGI 解释器进程(可见多个 php-cgi )并等待来自 Web Server 的连接。
3. 当客户端请求到达 Web Server 时，FastCGI 进程管理器选择并连接到一个 CGI 解释器。Web Server 将 CGI 环境变量和标准输入发送到 FastCGI 子进程 php-cgi。
4. FastCGI 子进程完成处理后将标准输出和错误信息从同一连接返回 Web Server。当 FastCGI 子进程关闭连接时，请求便告处理完成。FastCGI 子进程接着等待并处理来自 FastCGI 进程管理器(运行在 Web Server 中)的下一个连接。 在 CGI 模式中，php-cgi 在此便退出了。

在上述情况中，你可以想象 CGI 通常有多慢。每一个 Web 请求 PHP 都必须重新解析 php.ini、重新载入全部扩展并重初始化全部数据结构。使用 FastCGI，所有这些都只在进程启动时发生一次。一个额外的好处是，持续数据库连接(Persistent database connection)可以工作。

## FastCGI 的不足

因为是多进程，所以比 CGI 多线程消耗更多的服务器内存，PHP-CGI 解释器每进程消耗 7 至 25 兆内存，将这个数字乘以 50 或 100 就是很大的内存数。

# PHP-CGI

PHP-CGI 是 PHP 自带的 FastCGI 管理器。

## PHP-CGI 的不足

1. php-cgi 变更 php.ini 配置后需重启 php-cgi 才能让新的 php-ini 生效，不可以平滑重启。
2. 直接杀死 php-cgi 进程，php就不能运行了。(PHP-FPM 和 Spawn-FCGI就没有这个问题，守护进程会平滑从新生成新的子进程。）

# PHP-FPM

PHP-FPM 是一个 PHP FastCGI 管理器，是只用于 PHP 的，可以在 http://php-fpm.org/download 下载得到。

PHP-FPM 其实是 PHP 源代码的一个补丁，旨在将 FastCGI 进程管理整合进 PHP 包中。必须将它 patch 到你的 PHP 源代码中，在编译安装 PHP 后才可以使用。  

我们可以在PHP 5.3.2 的源码树里下载得到直接整合了 PHP-FPM 的分支，据说下个版本会融合进 PHP 的主分支去。相对 Spawn-FCGI，PHP-FPM 在 CPU 和内存方面的控制都更胜一筹，而且前者很容易崩溃，必须用 crontab 进行监控，而 PHP-FPM 则没有这种烦恼。  

PHP 5.3.3 已经集成 php-fpm 了，不再是第三方的包了。  
PHP-FPM 提供了更好的 PHP 进程管理方式，可以有效控制内存和进程、可以平滑重载 PHP 配置，比 spawn-fcgi 具有更多有点，所以被 PHP 官方收录了。在 ./configure 的时候带 –enable-fpm 参数即可开启 PHP-FPM。

# Spawn-FCGI

Spawn-FCGI 是一个通用的 FastCGI 管理服务器，它是 Lighttpd 中的一部分，很多人都用 Lighttpd 的 Spawn-FCGI 进行 FastCGI 模式下的管理工作，不过有不少缺点。而 PHP-FPM 的出现多少缓解了一些问题，但 PHP-FPM 有个缺点就是要重新编译，这对于一些已经运行的环境可能有不小的风险，在 PHP 5.3.3 中可以直接使用 PHP-FPM了。  

Spawn-FCGI 目前已经独成为一个项目，更加稳定一些，也给很多 Web 站点的配置带来便利。

# PHP-FPM 与 Spawn-FCGI 对比

PHP-FPM 的使用非常方便，配置都是在 PHP-FPM.ini 的文件内，而启动、重启都可以从 php/sbin/PHP-FPM中进行。  
更方便的是修改 php.ini后可以直接使用 PHP-FPM reload 进行加载，无需杀掉进程就可以完成 php.ini的修改加载。  

结果显示使用 PHP-FPM 可以使 PHP 有不小的性能提升。PHP-FPM 控制的进程 CPU 回收的速度比较慢,内存分配的很均匀。  
Spawn-FCGI 控制的进程 CPU 下降的很快，而内存分配的比较不均匀。有很多进程似乎未分配到，而另外一些却占用很高。可能是由于进程任务分配的不均匀导致的。而这也导致了总体响应速度的下降。而 PHP-FPM 合理的分配，导致总体响应的提到以及任务的平均。

# Ref
[概念了解：CGI，FastCGI，PHP-CGI与PHP-FPM](http://www.nowamagic.net/librarys/veda/detail/1319/)   
[关于CGI 和 PHP-FPM需要弄清的](http://www.cleey.com/blog/single/id/848.html)  
[搞不清FastCgi与PHP-fpm之间是个什么样的关系](https://segmentfault.com/q/1010000000256516)  
