---
layout: post
title: 使用Shell Script比较换算iPhone价格
description: "使用Shell Script比较换算iPhone价格"
category: Shell
avatarimg:
tags: [iPhone, Yahoo]
duoshuo: true
---

# 引言
最近在关注iPhone 6s Plus价格，每次去不同国家官网看了价格，然后换算成人民币，有点烦琐，于是写了个Shell脚本来做个这个事。

# iPhone不同国家价格获取及转换成人民币
以下是脚本内容：


```bash
#!/bin/bash

echo
echo "[1] iPhone 6s 5.5-inch-display-64gb-rose-gold"
echo 

read -p "Please choose one iPhone product listed above(enter the number): " Product_ID

echo $Product_ID

if [ $Product_ID -eq 1 ]
then

        Product_Model="iphone6s/5.5-inch-display-64gb-rose-gold"
        Product_US_URL="http://www.apple.com/us/shop/buy-iphone/${Product_Model}"
        Product_HK_URL="http://www.apple.com/hk/shop/buy-iphone/${Product_Model}"
        Product_CN_URL="http://www.apple.com/cn/shop/buy-iphone/iphone6s/5.5-%E8%8B%B1%E5%AF%B8%E5%B1%8F%E5%B9%95-64gb-%E7%8E%AB%E7%91%B0%E9%87%91%E8%89%B2"
        Product_CN_Search_String="iphone6s/5.5-%E8%8B%B1%E5%AF%B8%E5%B1%8F%E5%B9%95-64gb-%E7%8E%AB%E7%91%B0%E9%87%91%E8%89%B2"

        Product_US_Price=`curl -S $Product_US_URL 2>/dev/null | grep --color=auto "${Product_Model}\".*data" -A 9 | grep "$.*$" | uniq | awk -F "$" '{print $2}'`
        Product_HK_Price=`curl -S $Product_HK_URL 2>/dev/null | grep --color=auto "${Product_Model}\".*data" -A 9 | grep "$.*$" | uniq | awk -F "$" '{print $2}' | sed "s#,##g"`
        Product_CN_Price=`curl -S $Product_CN_URL 2>/dev/null | grep --color=auto "${Product_CN_Search_String}" -A 9 | grep RMB | awk -F " " '{print $2}' | sed "s#,##g"`

        USD_CNY_Rate=`curl -S "http://download.finance.yahoo.com/d/quotes.csv?e=.csv&f=sl1d1t1&s=USDCNY=x" 2>/dev/null | awk -F "," '{print $2}'`
        HKD_CNY_Rate=`curl -S "http://download.finance.yahoo.com/d/quotes.csv?e=.csv&f=sl1d1t1&s=HKDCNY=x" 2>/dev/null | awk -F "," '{print $2}'`

        echo "$Product_Model in US, HK, CN on $(date +%F):"
        echo "The US Version in CNY is:  `echo "$Product_US_Price * $USD_CNY_Rate" | bc`"
        echo "The HK Version in CNY is:  `echo "$Product_HK_Price * $HKD_CNY_Rate" | bc`"
        echo "The CN Version in CNY is:  $Product_CN_Price"

fi

```       

以上只列了一个我关注的iPhone型号，脚本逻辑很简单，模拟人工的操作，首先指定iPhone型号的对应的URL，然后通过curl和grep/awk/sed等命令获取iPhone的价格，再就是获取当日汇率（使用yahoo提供的API），最后就是换算成人民币输出结果了。

运行结果如下：

```bash
[root@Aliyun-BJ-01 test]# sh Apple-Products-Prices-Converter.sh 

[1] iPhone 6s 5.5-inch-display-64gb-rose-gold

Please choose one iPhone product listed above(enter the number): 1
1
iphone6s/5.5-inch-display-64gb-rose-gold in US, HK, CN on 2016-01-16:
The US Version in CNY is:  5573.7699
The HK Version in CNY is:  6054.4524
The CN Version in CNY is:  6888
```     


# Ref
[调用YAHOO API监控外汇汇率](http://raynix.info/archives/2216)  
[通过Yahoo API获取实时货币汇率代码](http://www.diebiang.com/webdev/_shijiyingyong_shixianshili_tongguoYahoo_APIhuoqushishihuobihuilvdaima_15.html)  

