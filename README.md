
# rstatscn

rstatscn是一个R包，它提供了一些访问中国国家数据的一些方便的接口。可以比较方便的获取想要的国家数据。
安装方法

```R
install.packages('rstatscn')
```

它可以方便的获取各种国家统计数据。比如中国的每年人口数据，各省的GDP数据，各种教育数据等。

# 目录
 - 简介  
 - 最近版本  
 - 函数介绍  
 - 常见问题  
 - 其他  
 - 实例 
 - 查询可用的数据库和指标  
 - 查询数据库中的数据 — 基础查询  
 - 查询数据库中的数据 — 分省数据查询  
 - 分省数据查询 — 同时查询所有省份的数据

# 简介
rstatscn是一个R包，它提供了一些访问中国国家数据的一些方便的接口。可以在R中获取想要的国家数据，比如中国的每年人口数据，各省的GDP数据，各种教育数据等

## 安装方法

```R
install.packages('rstatscn')
```
github page: https://github.com/jiang-hang/rstatscn

# 最近版本
## 2016.7.21 版本 1.1.1

- 修复行名重复的问题，如果你碰到这个问题
`Error in row.names<-.data.frame(*tmp*, value = value): duplicate 'row.names' are not allowed`
请首先调用`statscnRowNamePrefix()`,然后再查询数据库，这样在生成的dataframe中行的名字前会添加一个行号。要取消行号，调用`statscnRowNamePrefix(NULL)`

## 2016.2.25 版本 1.0.2
- 修复一个http状态检查的bug，需要httr >= 1.1.0

# 函数介绍
成功安装了rstatscn以后，可以利用`help(package="rstatscn")`获得在线帮助。用`help(<函数名>)`获得函数的说明。
 ## `statscnDbs()`
   列出国家数据库中可用的数据库，其中数据库的代码很重要，后面的函数查询中需要设定要查询数据库的代码 
 ## `statscnQueryZb(zbid='zb', dbcode='hgnd')`
 查询给定数据库中可用的指标。数据库中的指标是以树的结构组织的。查询根结点下的可用指标时，传入`zbid='zb'`即可。在获取的指标数据框中，如果这个指标不是叶节点，可以再利用这个函数来获得其子指标。如果`zbid`指定的指标已经是叶节点，那么将返回空的数据框。 
 ## `statscnRegions(dbcode='fsnd')`
 获得指定数据库中的区域代码。这个函数可以用来获取各省的代码。获取省的代码以后，可以查询指定省份的数据。在城市数据库中，可以用来获得城市代码。国际数据库中，用来获得国家的代码 
 ## `statscnQueryData(zb,dbcode,rowcode,colcode,moreWd)`
   这个是真正的数据查询函数，其中`zb`要查询的指标`id`，这个`id`不能随便写，需要根据`statscnQueryZbs`函数的返回值来设定 
 ## `dbcode` 
 要查询的数据库的代码，来源于`statscnDbs()`函数
 ## `rowcode`
 返回数据框的行代码，缺省值为`zb`，即指标，一般设为缺省值即可
 ## `colcode`
 返回数据框的列代码，缺省值为sj，即时间，一般设为缺省值即可
 ## `moreWd`
   对查询数据的更多限制。参数的格式为`moreWd=list(name=NA,value=NA)`。比如说在省份数据库中，在指定了要查询的zb以后，还可通过这个参数指定需要查询的省份。更多可见后面的例子。
 ## `statscnQueryLastN(n)`
   修改前一次查询，查询最新的n条数据，每次查询时，会缺省返回一些数据，如果你想获得更多的数据或者更少的数据，可以利用这个函数。这个函数只是修改返回数据的条数。注意，这个函数要在`statscnQueryData`之后调用，不然他不知道要修改哪条查询。

# 常见问题
## 找不到rstatscn包？
检查一下你R的版本，rstatscn在3.2.2及以上版本才可用。（因为没有在低版本测试过）

## 数据的实时性怎样？
函数获取的数据和网站http://data.stats.gov.cn中展示的数据是一致的。 如果获取的数据和网站展示的数据不一致，那应该是一个程序错误，可以告诉我

## 其他
我把国家数据库中的所有指标都列出来了。放在这里，以后就不必要每次去查了。 (2015-11-30日数据，仅供参考)

在每个叶子指标下可能还会有多个指标，比如`A0101`行政区划下，还有11个指标，这个可以通过`statscnQueryData('A0101')`的返回值 看到。这些指标也有自己的`id`，按照返回的行的顺序，`id`分别为`A0101 + 0<行号>`，`9`以后的编码为字母`A,B,…`比如第一行—地级区划数(个)—的`id`为`A010101` , 第11行的指标——街道办事处(个)——`id` 为`A01010B`。知道了这些指标的id以后，可以通过`statscnQueryData('A01010B')`来直接查询这个指标，这样就不会返回一系列的指标值了。

# 实例
## 查询可用的数据库和指标
首先利用`statscnDbs`查询可用数据库，然后可根据数据库名字查询各数据库可用的指标。如下所示：
```R
> library(rstatscn)
> statscnDbs()
    dbcode                                    description       description_zh
1     hgnd                          national data, yearly             宏观年度
2     hgjd                       national data, quarterly             宏观季度
3     hgyd                         national data, monthly             宏观月度
4     fsnd                          province data, yearly             分省年度
5     fsjd                       province data, quarterly             分省季度
6     fsyd                         province data, monthly             分省月度
7     csnd                              city data, yearly             城市年度
8     csyd                             city data, monthly             城市月度
9    gatnd          Hong Kong, Macao, Taiwan data, yearly           港澳台年度
10   gatyd         Hong Kong, Macao, Taiwan data, monthly           港澳台月度
11    gjnd                     international data, yearly             国际年度
12    gjyd                    international data, monthly             国际月度
13 gjydsdj                 3 main countries data, monthly       三大经济体月度
14  gjydsc international market commodity prices, monthly 国际市场月度商品价格
```
```R
> statscnQueryZb(dbcode='hgnd')
   dbcode  id isParent                     name pid wdcode
1    hgnd A01     TRUE                     综合         zb
2    hgnd A02     TRUE             国民经济核算         zb
3    hgnd A03     TRUE                     人口         zb
4    hgnd A04     TRUE           就业人员和工资         zb
5    hgnd A05     TRUE     固定资产投资和房地产         zb
6    hgnd A06     TRUE             对外经济贸易         zb
7    hgnd A07     TRUE                     能源         zb
8    hgnd A08     TRUE                     财政         zb
9    hgnd A09     TRUE                 价格指数         zb
10   hgnd A0A     TRUE                 人民生活         zb
11   hgnd A0B     TRUE                 城市概况         zb
12   hgnd A0C     TRUE               资源和环境         zb
13   hgnd A0D     TRUE                     农业         zb
14   hgnd A0E     TRUE                     工业         zb
15   hgnd A0F     TRUE                   建筑业         zb
16   hgnd A0G     TRUE               运输和邮电         zb
17   hgnd A0H    FALSE       社会消费品零售总额         zb
18   hgnd A0I     TRUE             批发和零售业         zb
19   hgnd A0J     TRUE             住宿和餐饮业         zb
20   hgnd A0K     TRUE                   旅游业         zb
21   hgnd A0L     TRUE                   金融业         zb
22   hgnd A0M     TRUE                     教育         zb
23   hgnd A0N     TRUE                     科技         zb
24   hgnd A0O     TRUE                     卫生         zb
25   hgnd A0P     TRUE                 社会服务         zb
26   hgnd A0Q     TRUE                     文化         zb
27   hgnd A0R     TRUE                     体育         zb
28   hgnd A0S     TRUE 公共管理、社会保障及其他         zb
```
```R
> statscnQueryZb('A01',dbcode='hgnd')
  dbcode    id isParent                   name pid wdcode
1   hgnd A0101    FALSE               行政区划 A01     zb
2   hgnd A0102    FALSE 人均主要工农业产品产量 A01     zb
3   hgnd A0103     TRUE             法人单位数 A01     zb
4   hgnd A0104     TRUE         企业法人单位数 A01     zb
5   hgnd A0105     TRUE           民族自治地方 A01     zb
```

## 查询数据库中的数据
### 基础查询
知道了数据库中的指标以后，就可以根据指标和数据库来查询数据了。通常要查询更多的数据，需要两次查询。如下所示：
```R
> statscnQueryData('A0102',dbcode='hgnd')
                           2014年     2013年      2012年
粮食人均占有量(公斤)            0 443.456070  436.500957
棉花人均占有量(公斤)            0   4.640549    5.061080
油料人均占有量(公斤)            0  25.910172   25.444427
糖料人均占有量(公斤)            0 101.300000   99.840657
茶叶人均产量(公斤)              0   1.320000    1.325061
水果人均占有量(公斤)            0 184.900000  178.107095
猪牛羊肉人均占有量(公斤)        0  48.644283   47.427051
水产品人均占有量(公斤)          0  45.469971   43.738046
人均原煤产量(吨)                0   0.000000    2.702313
人均原油产量(公斤)              0   0.000000  153.608328
人均纱产量(公斤)                0   0.000000   22.092330
人均布产量(米)                  0   0.000000   62.852087
人均机制纸及纸板产量(公斤)      0   0.000000   81.117795
人均水泥产量(公斤)              0   0.000000 1636.076835
人均粗钢产量(公斤)              0   0.000000  535.933131
人均发电量(千瓦小时)            0   0.000000 3692.582707
```
```R
> statscnQueryLastN(4)
                           2014年     2013年      2012年      2011年
粮食人均占有量(公斤)            0 443.456070  436.500957  425.152645
棉花人均占有量(公斤)            0   4.640549    5.061080    4.904187
油料人均占有量(公斤)            0  25.910172   25.444427   24.612319
糖料人均占有量(公斤)            0 101.300000   99.840657   93.119565
茶叶人均产量(公斤)              0   1.320000    1.325061    1.207632
水果人均占有量(公斤)            0 184.900000  178.107095  169.389736
猪牛羊肉人均占有量(公斤)        0  48.644283   47.427051   45.355827
水产品人均占有量(公斤)          0  45.469971   43.738046   41.704897
人均原煤产量(吨)                0   0.000000    2.702313    2.618794
人均原油产量(公斤)              0   0.000000  153.608328  150.934433
人均纱产量(公斤)                0   0.000000   22.092330   20.220217
人均布产量(米)                  0   0.000000   62.852087   60.570034
人均机制纸及纸板产量(公斤)      0   0.000000   81.117795   81.918341
人均水泥产量(公斤)              0   0.000000 1636.076835 1561.797296
人均粗钢产量(公斤)              0   0.000000  535.933131  509.833945
人均发电量(千瓦小时)            0   0.000000 3692.582707 3506.371408
```
### 分省数据查询
对于分省数据库而言，可以首先查询省份（即地区）的代码，然后再根据省份代码和指标来查询给定年/月度的数据。
```R
> statscnQueryZb('A01',dbcode='fsnd')
  dbcode    id isParent           name pid wdcode
1   fsnd A0101    FALSE       行政区划 A01     zb
2   fsnd A0102     TRUE     法人单位数 A01     zb
3   fsnd A0103     TRUE 企业法人单位数 A01     zb
```
```R
> statscnRegions(dbcode='fsnd')
   regCode             name
1   110000           北京市
2   120000           天津市
3   130000           河北省
4   140000           山西省
5   150000     内蒙古自治区
6   210000           辽宁省
7   220000           吉林省
8   230000         黑龙江省
9   310000           上海市
10  320000           江苏省
11  330000           浙江省
12  340000           安徽省
13  350000           福建省
14  360000           江西省
15  370000           山东省
16  410000           河南省
17  420000           湖北省
18  430000           湖南省
19  440000           广东省
20  450000   广西壮族自治区
21  460000           海南省
22  500000           重庆市
23  510000           四川省
24  520000           贵州省
25  530000           云南省
26  540000       西藏自治区
27  610000           陕西省
28  620000           甘肃省
29  630000           青海省
30  640000   宁夏回族自治区
31  650000 新疆维吾尔自治区
```

#### 获取分省年度数据库中天津的A0101指标
```R
> statscnQueryData('A0101',dbcode='fsnd',moreWd=list(name='reg',value='120000'))
                 2014年 2013年 2012年 2011年
地级区划数(个)        0      0      0      0
地级市数(个)          0      0      0      0
县级区划数(个)       16     16     16     16
市辖区数(个)         13     13     13     13
县级市数(个)          0      0      0      0
县数(个)              3      3      3      3
自治县数(个)          0      0      0      0
乡镇级区划数(个)    240    240    245    244
镇数(个)            121    121    123    123
乡数(个)              6      6     11     11
街道办事处(个)      113    113    111    110
```
#### 获取最近20年的天津A0101指标
```R
>statscnQueryLastN(20)
...
```
### 同时查询所有省份的数据
每次查询返回的数据是一个二维的表格，缺省情况下，行为指标，列为时间。要查询所有省的数据，只需要指定指标和数据库名，然后指定行为省份，即`rowcode='reg'`，如下所示。注意这里的`A010101`指标是地级区划个数。因此，要查询所有省份的数据，需要精确指定指标代码，指定组的代码将会返回该组的第一个自指标数据。比如指定`A0101`，返回的数据实际上是`A010101`的数据。
```R
> statscnQueryData("A010101",dbcode='fsnd',rowcode='reg')
                 2014年 2013年 2012年 2011年 2010年 2009年 2008年 2007年 2006年
北京市                0      0      0      0      0      0      0      0      0
天津市                0      0      0      0      0      0      0      0      0
河北省               11     11     11     11     11     11     11     11     11
山西省               11     11     11     11     11     11     11     11     11
内蒙古自治区         12     12     12     12     12     12     12     12     12
辽宁省               14     14     14     14     14     14     14     14     14
吉林省                9      9      9      9      9      9      9      9      9
黑龙江省             13     13     13     13     13     13     13     13     13
上海市                0      0      0      0      0      0      0      0      0
江苏省               13     13     13     13     13     13     13     13     13
浙江省               11     11     11     11     11     11     11     11     11
安徽省               16     16     16     16     17     17     17     17     17
福建省                9      9      9      9      9      9      9      9      9
江西省               11     11     11     11     11     11     11     11     11
山东省               17     17     17     17     17     17     17     17     17
河南省               17     17     17     17     17     17     17     17     17
湖北省               13     13     13     13     13     13     13     13     13
湖南省               14     14     14     14     14     14     14     14     14
广东省               21     21     21     21     21     21     21     21     21
广西壮族自治区       14     14     14     14     14     14     14     14     14
海南省                3      3      3      2      2      2      2      2      2
重庆市                0      0      0      0      0      0      0      0      0
四川省               21     21     21     21     21     21     21     21     21
贵州省                9      9      9      9      9      9      9      9      9
云南省               16     16     16     16     16     16     16     16     16
西藏自治区            7      7      7      7      7      7      7      7      7
陕西省               10     10     10     10     10     10     10     10     10
甘肃省               14     14     14     14     14     14     14     14     14
青海省                8      8      8      8      8      8      8      8      8
宁夏回族自治区        5      5      5      5      5      5      5      5      5
新疆维吾尔自治区     14     14     14     14     14     14     14     14     14
```
如果要查询一组指标或查询给定年度的数据必须指定时间。指定时间的方式是使用参数`moreWd=list((name='sj'),value='2015')`<sup>1</sup>。然后通过`rowcode='reg'`指定返回表格的行为省份，`colcode='zb'`指定列为指标。如下所示：


#### 获取所有省份2015年的A010101指标
```R
> statscnQueryData('A010101',dbcode='fsnd',rowcode='reg',colcode='zb',moreWd=list((name='sj'),value='2015'))
      地级区划数
 北京市                    0
 天津市                    0
 河北省                   11
 山西省                   11
 内蒙古自治区             12
 辽宁省                   14
 吉林省                    9
 黑龙江省                 13
 上海市                    0
 江苏省                   13
 浙江省                   11
 安徽省                   16
 福建省                    9
 江西省                   11
 山东省                   17
 河南省                   17
 湖北省                   13
 湖南省                   14
 广东省                   21
 广西壮族自治区           14
 海南省                    3
 重庆市                    0
 四川省                   21
 贵州省                    9
 云南省                   16
 西藏自治区                7
 陕西省                   10
 甘肃省                   14
 青海省                    8
 宁夏回族自治区            5
 新疆维吾尔自治区         14
  ```
                 
#### 获取所有省份2015年的`A0101`指标
和上面的命令相比，这个会取出所有`A0101`下的子指标
```R
> statscnQueryData('A0101',dbcode='fsnd',rowcode='reg',colcode='zb',moreWd=list((name='sj'),value='2015'))
                 地级区划数 地级市数 县级区划数 市辖区数 县级市数 县数 自治县数
北京市                    0        0         16       14        0    2        0
天津市                    0        0         16       13        0    3        0
河北省                   11       11        171       39       20  106        6
山西省                   11       11        119       23       11   85        0
内蒙古自治区             12        9        102       22       11   17        0
辽宁省                   14       14        100       56       17   19        8
吉林省                    9        8         60       21       20   16        3
黑龙江省                 13       12        128       65       17   45        1
上海市                    0        0         17       16        0    1        0
江苏省                   13       13         99       55       23   21        0
浙江省                   11       11         90       35       20   34        1
安徽省                   16       16        105       43        6   56        0
福建省                    9        9         85       28       13   44        0
江西省                   11       11        100       20       10   70        0
山东省                   17       17        137       51       28   58        0
河南省                   17       17        158       50       21   87        0
湖北省                   13       12        103       39       24   37        2
湖南省                   14       13        122       35       16   64        7
广东省                   21       21        119       61       21   34        3
广西壮族自治区           14       14        110       36        7   55       12
海南省                    3        3         24        8        6    4        6
重庆市                    0        0         38       21        0   13        4
四川省                   21       18        183       49       14  116        4
贵州省                    9        6         88       14        7   55       11
云南省                   16        8        129       13       13   74       29
西藏自治区                7        3         74        3        0   71        0
陕西省                   10       10        107       25        3   79        0
甘肃省                   14       12         86       17        4   58        7
青海省                    8        2         43        5        3   28        7
宁夏回族自治区            5        5         22        9        2   11        0
新疆维吾尔自治区         14        2        103       11       24   62        6

#后面还有几个指标，这里略去
```
--------------------------------------------------------------------------------

1. 这里好象有个bug，如果`name='sj'`不加括号会报错。报错的内容为`Error in seq.default(1, nrow(dfdata)) : 'to' must be of length 1`
