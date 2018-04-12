单机系统性能优化

# 从一个 HTTP 请求开始


![From-One-HTTP-Request-Begin](http://jaminzhang.github.io/images/Web-Architecture-One-Box/01-From-One-HTTP-Request-Begin.png)  

1. 用户浏览器发送 HTTP 请求经过网络到达 Web 服务器。
2. Web 服务器处理请求，并生成响应数据。
3. 响应数据从 Web 服务器发送到用户端。
4. 用户浏览器接收响应数据，进行本地计算和渲染。

上面的过程中花费的时间可以分成几个部分，可以分别进行优化减少这些时间，从而提高 Web 系统的性能。

## 相关术语

吞吐率、响应时间、支持的并发、PV  

网站架构与业务相关：比如小说网站（静态）、电商网站（动态）

[Chrome 浏览器开发者工具中的时间分解说明](https://developers.google.com/web/tools/chrome-devtools/network-performance/reference#timing-breakdown)  

![HTTP-Time-Spent](http://jaminzhang.github.io/images/Web-Architecture-One-Box/02-HTTP-Time-Spent.png)  
![HTTP-Time-Spent](http://jaminzhang.github.io/images/Web-Architecture-One-Box/03-HTTP-Time-Spent.png)  

## 1 浏览器与服务器 TCP 连接建立阶段的时间花费

主要分为：
* 1.1 DNS 解析的时间花费
* 1.2 建立 TCP 连接的时间花费


## 2 TCP 连接建立后的 HTTP 请求、响应时间花费

* 发送时间 + 传输时间 + 服务器处理时间 = 响应时间

* 发送时间 = 数据量比特数 / 比特数
* 传输时间 = 传播距离 / 传播速度
* 处理时间：服务器收到请求后生成响应数据的时间


![Reduce-Server-Handling-Time](http://jaminzhang.github.io/images/Web-Architecture-One-Box/04-Reduce-Server-Handling-Time.png)

如何缩短服务器的处理时间？

* 单机性能优化（Liunx 系统优化，CPU/RAM/IO 等的优化，Nginx 参数优化，MySQL 慢查询等）
* 使用集群
* 使用缓存
* 多机房部署，就近访问（CDN 在更前端）
* 定位瓶颈点（通用优化后还是慢的情况下，比如业务逻辑不合理，需要优化，）

# 单机时代-单机模式

![One-Box-Mode](http://jaminzhang.github.io/images/Web-Architecture-One-Box/05-One-Box-Mode.png)

1. 单台服务器 Web + DB
2. Apache + PHP(模块化方式调用)
3. 数据库每日凌晨备份，保存到本地


* 浏览器每个域名有并发下载限制，可以采用多域名
* Web 前端优化，如：懒加载（JS 捕获鼠标），加快首屏显示时间，减少带宽。


# 单机时代-动静分离

![Dynamic-Static-Separation](http://jaminzhang.github.io/images/Web-Architecture-One-Box/06-Dynamic-Static-Separation.png)  

1. 单台服务器 Web + DB
2. Nginx + PHP(FastCGI) 实现动静分离
3. 数据库每日凌晨备份，保存到本地


Nginx 多种用法，比如处理 SSL/记录访问日志/根据 UA/URL 来转发请求


# 单机时代-数据库分离

![Database-Separation](http://jaminzhang.github.io/images/Web-Architecture-One-Box/07-Database-Separation.png)  

1. 将 Web 服务器和 DB 服务器单独部署
2. 将 Web 服务器资源备份到 DB 服务器
3. 数据库每日凌晨备份到 Web 服务器

不能有单点故障。注意要有备份。

# 单机时代-组件分离

![Web-Components-Separation](http://jaminzhang.github.io/images/Web-Architecture-One-Box/08-Web-Components-Separation.png) 

1. 静态服务器使用单独的服务器。
2. 静态服务器使用独立一级域名防止 Cookie 提交。
3. 静态服务器可以使用多个二级域名提高加载速度。
4. 静态资源服务器作为 NFS 服务器，静态资源存放于 NFS 上。
5. 数据库每日凌晨备份保存到 NFS 上。

**相关概念**
* Session 
* Cookie

# 单机时代-Web 性能优化

![Web-Performance-Optimizing](http://jaminzhang.github.io/images/Web-Architecture-One-Box/09-Web-Performance-Optimizing.png)  


