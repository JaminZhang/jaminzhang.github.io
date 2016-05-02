---
layout: post
title: GitLab中配置添加SSH密钥
description: "GitLab中配置添加SSH密钥"
category: Linux
avatarimg:
tags: [GitLab, SSH]
duoshuo: true
---

# 引言
昨天说了要通过SSH协议来访问公司的GitLab，现在开始来配置下。

# GitLab简介
开始配置之前，我们先来了解下GitLab。

> 
GitLab，是一个利用 Ruby on Rails 开发的开源应用程序，实现一个自托管的Git项目仓库，可通过Web界面进行访问公开的或者私人项目。 
它拥有与GitHub类似的功能，能够浏览源代码，管理缺陷和注释。可以管理团队对仓库的访问，它非常易于浏览提交过的版本并提供一个文件历史库。 
团队成员可以利用内置的简单聊天程序（Wall）进行交流。它还提供一个代码片段收集功能可以轻松实现代码复用，便于日后有需要的时候进行查找。 

>
Build together: GitLab includes Git repository management, code reviews, issue tracking, wikis, and more, plus GitLab CI, an easy-to-use continuous integration and deployment tool.

> 
Stay up-to-date: Collaborate with your team using issues, milestones, and line-by-line code review. View activity streams of projects or the people you work with.

> 
Plays well with others: GitLab seamlessly integrates with Slack, Hipchat, LDAP, JIRA, Jenkins, and many other popular tools. GitLab includes many webhooks and offers a complete API.

# GitLab配置添加SSH Key
这个在GitLab的/help/ssh/README这个URL有详细的说明，下面就写下重点部分。

## 1.客户端配置生成SSH密钥对

```bash
ssh-keygen -t rsa -C "YOUR EMAIL"
``` 

完成后在 ~/.ssh/ 会生成2个文件。id_rsa 和 id_rsa.pub。前者是私钥，注意保管，后者是公钥。

# 2.添加SSH Key到GitLab

登录GitLab之后: Profile Settings => SSH Keys => Add SSH key

输入之前生成的公钥，标题自定义。

这样就行了。

# Ref
[GitLab](https://about.gitlab.com/)  
[GitLab Wikipedia](https://en.wikipedia.org/wiki/GitLab)  
[Gitlab 简单配置使用](http://www.liaohuqiu.net/cn/posts/git-abc/)  
[GitLab的简单使用](http://blog.devzeng.com/blog/simple-usage-of-gitlab.html)  

