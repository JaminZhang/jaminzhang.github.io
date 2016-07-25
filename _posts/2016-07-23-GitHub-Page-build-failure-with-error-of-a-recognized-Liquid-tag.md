---
layout: post
title: GitHub Pages build failure with error of a recognized Liquid tag
description: "GitHub Pages build failure with error of a recognized Liquid tag"
category: Markdown
avatarimg:
tags: [GitHub, Markdown, Jekyll]
duoshuo: true
---

# 引言
这几天写 markdown 博客时，提交到 GitHub Pages 时，jekyll 并没有生成对应的网页。很是奇怪。  
我起初猜想是 GitHub 是不是抽风了。这样过了几天，今天新建空白 markdown 文档提交后依然没有看到生成对应的网页。到底是什么原因？

# GitHub Page build failure 

我想起我之前 GitHub Page build failure 会发邮件的，这个邮箱我没怎么登录使用。  
登录进去，果然有 Page build failure 的提示邮件。如下：

<The page build failed with the following error:

<pre>
The tag `elif` on line 235 in `_posts/2016-07-02-SaltStack-systematic-learning-05-Grains-Pillar.md` is not a recognized Liquid tag. For more information, see https://help.github.com/articles/page-build-failed-unknown-tag-error.

For information on troubleshooting Jekyll see:

  https://help.github.com/articles/troubleshooting-jekyll-builds

If you have any questions you can contact us by replying to this email.
</pre>


上面意思是说我写的那个 markdown 文档中的 `elif` 不是一个可以识别的 Liquid 标签。

<pre>
What is Liquid?

Liquid is an open-source template language created by Shopify and written in Ruby. It is the backbone of Shopify themes and is used to load dynamic content on storefronts.

Liquid has been in production use since June 2006 and is now used by many other hosted web applications.
</pre>

`elif` 那段代码是关于 SaltStack 中使用 Jinaja2 模板的，和 Liquid 标签冲突了，代码如下：

![Unrecognized-Liquid-tag](https://raw.githubusercontent.com/JaminZhang/jaminzhang.github.io/master/images/Jekyll/Unrecognized-Liquid-tag.png)  

解决办法：我截图展示上面的代码了，不然造成这篇 markdown 及之后的文档不能 build，造成引言中提到的问题。


