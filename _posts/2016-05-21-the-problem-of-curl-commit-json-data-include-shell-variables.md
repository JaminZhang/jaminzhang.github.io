---
layout: post
title: curl 提交 json 数据中引用 Shell 变量问题
description: "curl 提交 json 数据中引用 Shell 变量问题"
category: Shell
avatarimg:
tags: [curl, json, POST, GET, Shell]
duoshuo: true
---

# 引言

某业务配置完成后需要提交数据到一 API 接口，提交命令在 Shell 中，首先想到使用的 json 数据，其中引用了 Shell 变量。

# 问题：Shell 变量没解析成功及解决方法

curl 提交数据部分如下：

```bash
curl -XPOST -H "Content-Type: application/json" http://admin.xxx.cn/xxx/AddServer \
-d '{\
"platform_name":"${PLATFORM}", \
"region_id":"${SID}", \
"game_db_ip":"${GAME_DOMAIN}", \
"game_ip":"${GAME_DOMAIN}", \
"log_db_ip":"admin.xxx.cn", \
"server_type":"3", \
"server_state":"1", \
"main_server":"0"\
}'
```    

其中上面引用的 Shell 变量没有被解析。主要是引号问题。curl 中引号说明如下：

> 
The double quotes in the -H arguments (as in -H "foo bar") tell bash to keep what's inside as a single argument (even if it contains spaces).  
The single quotes in the --data argument (as in --data 'foo bar') do the same, except they pass all text verbatim (including double quote characters and the dollar sign).  
To insert a variable in the middle of a single quoted text, you have to end the single quote, then concatenate with the double quoted variable, and re-open the single quote to continue the text: 'foo bar'"$variable"'more foo'.


如上，想要 Shell 变量被解析，修改成如下的引号引用变量：

```bash
curl -XPOST -H "Content-Type: application/json" http://admin.xxx.cn/zmsgApi/xxx/AddServer \
-d '{\
"platform_name":"'"${PLATFORM}"'", \
"region_id":"'"${SID}"'", \
"game_db_ip":"'"${GAME_DOMAIN}"'", \
"game_ip":"'"${GAME_DOMAIN}"'", \
"log_db_ip":"admin.xxx.cn", \
"server_type":"3", \
"server_state":"1", \
"main_server":"0"\
}'
```    

# 后续

使用上面的方法可以正确解析 Shell 变量，但又遇到另一个问题，看上面的提交命令，为了易读，使用了断行符“\”，  
引发的问题是 curl 提交过去会出现问题。  
于是最终不使用这种 curl POST 提交 json 数据的方法，直接通过 GET 提交，在 URL 包含参数的方法。如下：  

```bash
curl "http://admin.xxx.cn/xxx/AddServer?platform_name=${PLATFORM}&region_id=${SID}\
&game_db_ip=${GAME_DOMAIN}&game_ip=${GAME_DOMAIN}&log_db_ip=admin.xxx.cn&server_type=3&server_state=1&main_server=0"
```    

# Ref
[Using curl POST with variables defined in bash script functions](http://stackoverflow.com/questions/17029902/using-curl-post-with-variables-defined-in-bash-script-functions)　　　
