# 修改部分配置用于自己个人博客的编写
具体配置暂未说明

UPDATE 2016-06-20, by Jamin Zhang

# Jekyll主题 &bull;JekyllPure

fork Github:[JekyllPure'github](https://github.com/liyouhai/JekyllPure)
在此基础上修改了部分细节：

- M

    - 修改_config.yml文件，把与Jekyll相关的配置、博客和作者相关的说明都放在该文件内；
    - 修改时间轴以按月分类文章；
    - 修改代码高亮样式；
    - 修改左侧导航栏toc显示级数和边距；
    - 修改图片路径；
    - 修改翻页错误；
    - 修改index页tag、category错误；

- A

    - 增加底部的知识共享许可协议说明；
    - 增加归档页面的文章描述;

- D

    - 删除搜索框；

你可以通过如下命令查找所有修改的内容：

    $ grep -rw --exclude-dir="_site" "weiyi.theme" .

UPDATE 2014-10-08, by weiyi.li
