---
layout: post
title: Markdown Test
category: LDD
tags:
description: this is a post description, you can use variable {{post.description}} to show it in wherever you want.
---

# 标题1 

## 标题1.1
 
### 标题1.1.1

#### 标题1.1.1.1

# 标题 2
 
- 列表1
 
测试
 
- 列表2
- 列表3
 
<!-- more -->
 
水平线
 
----------------------------
 
1. 列表1
2. 列表2
3. 列表3
5. 顺序错了不用担心
3. 写错的列表，会自动纠正
 
 
如果文字后面紧跟着水平线，看看是什么效果
---------------------
 
漂亮的代码，还可以自动高亮


    int i = 0;
    i = 1;
    for (int i = 0; i < 100; i++)
    {
        printf("hello markdown!\n");
    }

```c    
int i = 0;
i = 1;
for (int i = 0; i < 100; i++)
{
    printf("hello markdown!\n");
}
```

```html
<div class="qrcodeTable"></div>
<header class="post-header">
    <img class="post-avatar" height="48" width="48"
         src="{{ page.avatarimg }}">

    <h2 class="post-title">{{ page.title }}</h2>

    <p class="post-meta">By {{ page.date | date: "%m" }}月{{ page.date | date: "%d" }}日  {{ page.date | date: "%Y" }}
            <!-- weiyi.theme.modify 修复tag枚举错误
            参考hpstr主题的post.html -->
            <a
            class="post-categorybut " href="/type/#{{ post.categories  }}">{{ page.categories  }}
            </a>
            <a
            class="post-category " {% for tag in page.tags %}<a href="{{ site.url }}/tags/#{{ tag }}" title="Pages tagged {{ tag }}" class="post-category">{{ tag }}</a>{% unless forloop.last %}{% endunless %}{% endfor %}
            </a>
    </p>
</header>
```


This is a sentence.[^1]

行内代码`main(){return 0}` 
行内代码 main(){return 0} 

 
*我是斜体*
测试文字里面，**我是粗体**，很简单
__我是粗体__


我是表格

| 需要匹配的      | BRE         | ERE       |
|:--------------: |:-----------:|:---------:|
| 重复5个a        | `a\{5\}`    | `a{5}`    |
| 重复5～10个a    | `a\{5,10\}` | `a{5,10}` |
 

> 我是引用

"我是双引号"


[^1]: This is a footnote.



