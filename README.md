
#### name 批量ip归属地查询，调用阿里ip库接口

### useage：


### 使用用方法： ./ipwhere.pl 8.8.8.8 8.8.8.6 

##结果展示
perl ipwhere.pl 223.123.123.45 203.123.123.123

taobao 223.123.123.45:中国,北京市,北京市,移动
taobao 203.123.123.123:澳大利亚,,,
sina 223.123.123.45:中国,北京,北京,
sina 203.123.123.123:澳大利亚,西澳大利亚,North Fremantle,
baidu 223.123.123.45:北京市西城区 移动
baidu 203.123.123.123:澳大利亚
pconline 223.123.123.45:,,, 中国移动
pconline 203.123.123.123:,,, 澳大利亚

##新增缓存机制，心增加新浪、百度和pconline ip调用接口


##新增加纯真数据,使用方法
   
   perl qqip.pl 116.211.167.14 
  
##备注：

   需要安装perl及扩展LWP::Simple ,JSON;
   可以通过cpanm 简单的安装: cpanm LWP::Simple JSON 

##
1103 qqip.pl 修正地址显示乱码,增加多ip查询
