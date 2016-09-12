---
layout: post
title: Docker 配置 HTTP 代理
description: "Docker 配置 HTTP 代理"
category: Docker
avatarimg:
tags: [Docker, HTTP, Proxy]
duoshuo: true
---

# 引言

由于某些原因，国内网络访问 Docker Hub 拉取官方 Docker 镜像时经常超时。  
怎么解决呢？可以使用 HTTP 代理来加速访问。  
（PS: 国内稍具规模的中大型技术公司应该有正常访问国外网站的代理服务器）

# Docker 配置 HTTP 代理

官网文档比较详细的写了配置过程，我这里记录下。

[Docker systemd http-proxy](https://docs.docker.com/engine/admin/systemd/#/http-proxy)
