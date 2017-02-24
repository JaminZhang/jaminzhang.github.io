---
layout: post
title: Nginx 优化总结
description: "Nginx 优化总结"
category: Nginx
avatarimg:
tags: [Web, Nginx, Optimization]
duoshuo: true
---

Nginx 优化总结


# 引言

现在的业务虽然也使用 Nginx，但 Nginx 已经是做好内部的 RPM 包，直接通过内部 YUM 源安装使用的。  
所以关于 Nginx 的优化之前有学习过，不过好久没有实际配置过，很多具体细节配置参数已经忘记了，现在查找相关资料，  
重新总结学习下。  

# Nginx 服务基础到架构优化

来自[企业级Nginx服务基础到架构优化详解--25条](http://lilongzi.blog.51cto.com/5519072/1839751)  

1. 隐藏 nginx header 版本号
2. 更改源码隐藏软件名称
3. 更改 nginx 默认用户及用户组
4. 配置 nginx worker 进程个数
5. 根据 CPU 核数进行 nginx 进程优化
6. nginx 事件处理模型优化
7. 调整 nginx worker 单个进程允许的客户端最大连接数
8. 配置 nginx worker 进程最大打开文件数
9. 开启高效的文件传输模式(sendfile/tcp_nopush/tcp_nodelay)
10. 设置连接超时时间
11. 上传文件大小设置（动态应用）
12. fastcgi 调优（配合 PHP 引擎动态服务）
13. 配置 nginx gzip 压缩功能
14. 配置 nginx expires 缓存功能
15. nginx 日志相关优化与安全
16. nginx 站点目录及文件 URL 访问控制（防止恶意解析）
17. 防止恶意解析访问企业网站
18. nginx 图片及目录防盗链
19. nginx 错误页面的优雅显示
20. nginx 防爬虫优化
21. 限制 HTTP 请求方法
22. 防 DOS 攻击
23. 使用 CDN 为网站内容加速
24. nginx 程序架构优化
25. 使用普通用户启动 nginx(监牢模式)

具体配置方法参考 Ref 中的文章。


# Ref
[企业级Nginx服务基础到架构优化详解--25条](http://lilongzi.blog.51cto.com/5519072/1839751)  
