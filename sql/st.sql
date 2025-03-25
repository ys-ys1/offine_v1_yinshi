drop table if exists ods_order_info;
create table ods_order_info (
                                `id` string COMMENT '订单编号',
                                `total_amount` decimal(10,2) COMMENT '订单金额',
                                `order_status` string COMMENT '订单状态',
                                `user_id` string COMMENT '用户id' ,
                                `payment_way` string COMMENT '支付方式',
                                `out_trade_no` string COMMENT '支付流水号',
                                `create_time` string COMMENT '创建时间',
                                `operate_time` string COMMENT '操作时间'
) COMMENT '订单表'
PARTITIONED BY ( `dt` string)
row format delimited  fields terminated by '\t'
location '/user/hive/warehouse/dev_realtime_yinshi.db/ods/ods_order_info/'
tblproperties ("parquet.compression"="snappy");

drop table if exists ods_order_detail;
create table ods_order_detail(
                                 `id` string COMMENT '订单编号',
                                 `order_id` string  COMMENT '订单号',
                                 `user_id` string COMMENT '用户id' ,
                                 `sku_id` string COMMENT '商品id',
                                 `sku_name` string COMMENT '商品名称',
                                 `order_price` string COMMENT '下单价格',
                                 `sku_num` string COMMENT '商品数量',
                                 `create_time` string COMMENT '创建时间'
) COMMENT '订单明细表'
PARTITIONED BY ( `dt` string)
row format delimited  fields terminated by '\t'
location '/user/hive/warehouse/dev_realtime_yinshi.db/ods/ods_order_detail/'
tblproperties ("parquet.compression"="snappy")
;

drop table if exists ods_sku_info;
create table ods_sku_info(
                             `id` string COMMENT 'skuId',
                             `spu_id` string  COMMENT 'spuid',
                             `price` decimal(10,2) COMMENT '价格' ,
                             `sku_name` string COMMENT '商品名称',
                             `sku_desc` string COMMENT '商品描述',
                             `weight` string COMMENT '重量',
                             `tm_id` string COMMENT '品牌id',
                             `category3_id` string COMMENT '品类id',
                             `create_time` string COMMENT '创建时间'
) COMMENT '商品表'
PARTITIONED BY ( `dt` string)
row format delimited  fields terminated by '\t'
location '/user/hive/warehouse/dev_realtime_yinshi.db/ods/ods_sku_info/'
tblproperties ("parquet.compression"="snappy")
;

drop table if exists ods_user_info;
create table ods_user_info(
                              `id` string COMMENT '用户id',
                              `name`  string COMMENT '姓名',
                              `birthday` string COMMENT '生日' ,
                              `gender` string COMMENT '性别',
                              `email` string COMMENT '邮箱',
                              `user_level` string COMMENT '用户等级',
                              `create_time` string COMMENT '创建时间'
) COMMENT '用户信息'
PARTITIONED BY ( `dt` string)
row format delimited  fields terminated by '\t'
location '/user/hive/warehouse/dev_realtime_yinshi.db/ods/ods_user_info/'
tblproperties ("parquet.compression"="snappy")
;

drop table if exists ods_base_category1;
create table ods_base_category1(
                                   `id` string COMMENT 'id',
                                   `name`  string COMMENT '名称'
) COMMENT '商品一级分类'
PARTITIONED BY ( `dt` string)
row format delimited  fields terminated by '\t'
location '/user/hive/warehouse/dev_realtime_yinshi.db/ods/ods_base_category1/'
tblproperties ("parquet.compression"="snappy")
;

drop table if exists ods_base_category2;
create external table ods_base_category2(
   `id` string COMMENT ' id',
   `name`  string COMMENT '名称',
  category1_id string COMMENT '一级品类id'
) COMMENT '商品二级分类'
PARTITIONED BY ( `dt` string)
row format delimited  fields terminated by '\t'
location '/user/hive/warehouse/dev_realtime_yinshi.db/ods/ods_base_category2/'
tblproperties ("parquet.compression"="snappy")
;

drop table if exists ods_base_category3;
create table ods_base_category3(
                                   `id` string COMMENT ' id',
                                   `name`  string COMMENT '名称',
                                   category2_id string COMMENT '二级品类id'
) COMMENT '商品三级分类'
PARTITIONED BY ( `dt` string)
row format delimited  fields terminated by '\t'
location '/user/hive/warehouse/dev_realtime_yinshi.db/ods/ods_base_category3/'
tblproperties ("parquet.compression"="snappy")
;

drop table if exists `ods_payment_info`;
create table  `ods_payment_info`(
                                    `id`  bigint COMMENT '编号',
                                    `out_trade_no`   string COMMENT '对外业务编号',
                                    `order_id`  string COMMENT '订单编号',
                                    `user_id`  string COMMENT '用户编号',
                                    `alipay_trade_no` string COMMENT '支付宝交易流水编号',
                                    `total_amount`  decimal(16,2) COMMENT '支付金额',
                                    `subject`  string COMMENT '交易内容',
                                    `payment_type` string COMMENT '支付类型',
                                    `payment_time`  string COMMENT '支付时间'
)  COMMENT '支付流水表'
PARTITIONED BY ( `dt` string)
row format delimited  fields terminated by '\t'
location '/user/hive/warehouse/dev_realtime_yinshi.db/ods/ods_payment_info/'
tblproperties ("parquet.compression"="snappy")
;

drop table if exists dwd_order_info;
create external table dwd_order_info (
   `id` string COMMENT '',
   `total_amount` decimal(10,2) COMMENT '',
   `order_status` string COMMENT ' 1 2  3  4  5',
  `user_id` string COMMENT 'id' ,
 `payment_way` string COMMENT '',
 `out_trade_no` string COMMENT '',
 `create_time` string COMMENT '',
 `operate_time` string COMMENT ''
) COMMENT ''
PARTITIONED BY ( `dt` string)
stored as  parquet
location '/user/hive/warehouse/dev_realtime_yinshi.db/dwd/dwd_order_info/'
tblproperties ("parquet.compression"="snappy")
;

drop table if exists dwd_order_detail;
create external table dwd_order_detail(
   `id` string COMMENT '',
  `order_id` decimal(10,2) COMMENT '',
  `user_id` string COMMENT 'id' ,
 `sku_id` string COMMENT 'id',
 `sku_name` string COMMENT '',
 `order_price` string COMMENT '',
 `sku_num` string COMMENT '',
 `create_time` string COMMENT ''
) COMMENT ''
PARTITIONED BY ( `dt` string)
stored as  parquet
location '/user/hive/warehouse/dev_realtime_yinshi.db/dwd/dwd_order_detail/'
tblproperties ("parquet.compression"="snappy")
;

drop table if exists dwd_user_info;
create external table dwd_user_info(
   `id` string COMMENT 'id',
   `name`  string COMMENT '',
  `birthday` string COMMENT '' ,
 `gender` string COMMENT '',
 `email` string COMMENT '',
 `user_level` string COMMENT '',
 `create_time` string COMMENT ''
) COMMENT ''
PARTITIONED BY ( `dt` string)
stored as  parquet
location '/user/hive/warehouse/dev_realtime_yinshi.db/dwd/dwd_user_info/'
tblproperties ("parquet.compression"="snappy")
;

drop table if exists `dwd_payment_info`;
create external  table  `dwd_payment_info`(
`id`  bigint COMMENT '',
`out_trade_no`  string COMMENT '',
`order_id`  string COMMENT '',
`user_id`  string COMMENT '',
`alipay_trade_no` string COMMENT '',
`total_amount`  decimal(16,2) COMMENT '',
`subject`  string COMMENT '',
`payment_type` string COMMENT '',
`payment_time`  string COMMENT ''
 )  COMMENT ''
PARTITIONED BY ( `dt` string)
stored as  parquet
location '/user/hive/warehouse/dev_realtime_yinshi.db/dwd/dwd_payment_info/'
tblproperties ("parquet.compression"="snappy");

drop table if exists dwd_sku_info;
create external table dwd_sku_info(
   `id` string COMMENT 'skuId',
   `spu_id` string COMMENT 'spuid',
  `price` decimal(10,2) COMMENT '' ,
 `sku_name` string COMMENT '',
 `sku_desc` string COMMENT '',
 `weight` string COMMENT '',
 `tm_id` string COMMENT 'id',
 `category3_id` string COMMENT '1id',
 `category2_id` string COMMENT '2id',
 `category1_id` string COMMENT '3id',
 `category3_name` string COMMENT '3',
 `category2_name` string COMMENT '2',
 `category1_name` string COMMENT '1',
 `create_time` string COMMENT ''
) COMMENT ''
PARTITIONED BY ( `dt` string)
stored as  parquet
location '/user/hive/warehouse/dev_realtime_yinshi.db/dwd/dwd_sku_info/'
tblproperties ("parquet.compression"="snappy")
;

set hive.exec.dynamic.partition.mode=nonstrict;

insert  overwrite table  dwd_order_info partition(dt)
select  * from ods_order_info
where dt='2025-03-23'  and id is not null;

insert  overwrite table   dwd_order_detail partition(dt)
select  * from ods_order_detail
where dt='2025-03-23'   and id is not null;

insert  overwrite table  dwd_user_info partition(dt)
select  * from ods_user_info
where dt='2025-03-23'   and id is not null;

insert  overwrite table  dwd_payment_info partition(dt)
select  * from ods_payment_info
where dt='2025-03-23'  and id is not null;

insert  overwrite table  dwd_sku_info partition(dt)
select
    sku.id,
    sku.spu_id,
    sku.price,
    sku.sku_name,
    sku.sku_desc,
    sku.weight,
    sku.tm_id,
    sku.category3_id,
    c2.id category2_id ,
    c1.id category1_id,
    c3.name category3_name,
    c2.name category2_name,
    c1.name category1_name,
    sku.create_time,
    sku.dt
from
    ods_sku_info sku
        join ods_base_category3 c3 on sku.category3_id=c3.id
        join ods_base_category2 c2 on c3.category2_id=c2.id
        join ods_base_category1 c1 on c2.category1_id=c1.id
where sku.dt='2025-03-23'  and c2.dt='2025-03-23'
  and  c3.dt='2025-03-23' and  c1.dt='2025-03-23'
  and sku.id is not null;

drop table if exists dwd_comment_log;
create external table dwd_comment_log
(
    mid_id       string,
    user_id      string,
    version_code string,
    version_name string,
    lang         string,
    source       string,
    os           string,
    area         string,
    model        string,
    brand        string,
    sdk_version  string,
    gmail        string,
    height_width string,
    app_time     string,
    network      string,
    lng          string,
    lat          string,
    comment_id   int,
    userid       int,
    p_comment_id int,
    content      string,
    addtime      string,
    other_id     int,
    praise_count int,
    reply_count  int,
    server_time  string
) COMMENT ''
PARTITIONED BY ( `dt` string)
row format delimited fields terminated by '\t'
location '/user/hive/warehouse/dev_realtime_yinshi.db/dwd/dwd_comment_log/'
tblproperties ("parquet.compression"="snappy")
;

LOAD DATA INPATH '/2207A/zhengwei_zhou/dwd_comment_log/2025-03-24/dwd_comment_log__484d57dc_620e_47f1_a278_36179bb4e144.gz'
    INTO TABLE dwd_comment_log;

drop table if exists dws_user_action;
create  external table dws_user_action
(
    user_id         string      comment '用户 id',
    order_count     bigint      comment '下单次数 ',
    order_amount    decimal(16,2)  comment '下单金额 ',
    payment_count   bigint      comment '支付次数',
    payment_amount  decimal(16,2) comment '支付金额 ',
    comment_count   bigint      comment '评论次数'
) COMMENT '每日用户行为宽表'
PARTITIONED BY ( `dt` string)
stored as  parquet
location '/user/hive/warehouse/dev_realtime_yinshi.db/dws/dws_user_action/'
tblproperties ("parquet.compression"="snappy");

with
    tmp_order as
        (
            select
                user_id,
                sum(oc.total_amount) order_amount,
                count(*)  order_count
            from dwd_order_info  oc
            where date_format(oc.create_time,'yyyy-MM-dd')='2019-02-10'
            group by user_id
        )  ,
    tmp_payment as
        (
            select
                user_id,
                sum(pi.total_amount) payment_amount,
                count(*) payment_count
            from dwd_payment_info pi
            where date_format(pi.payment_time,'yyyy-MM-dd')='2019-02-10'
            group by user_id
        ),
    tmp_comment as
        (
            select
                user_id,
                count(*) comment_count
            from dwd_comment_log c
            where date_format(c.dt,'yyyy-MM-dd')='2019-02-10'
            group by user_id
        )

insert overwrite table dws_user_action partition(dt='2025-03-23')
select
    user_actions.user_id,
    sum(user_actions.order_count),
    sum(user_actions.order_amount),
    sum(user_actions.payment_count),
    sum(user_actions.payment_amount),
    sum(user_actions.comment_count)
from
    (
        select
            user_id,
            order_count,
            order_amount ,
            0 payment_count ,
            0 payment_amount,
            0 comment_count
        from tmp_order

        union all
        select
            user_id,
            0,
            0,
            payment_count,
            payment_amount,
            0
        from tmp_payment

        union all
        select
            user_id,
            0,
            0,
            0,
            0,
            comment_count
        from tmp_comment
    ) user_actions
group by user_id;

drop table if exists ads_gmv_sum_day;
create table ads_gmv_sum_day(
                                `dt` string COMMENT '统计日期',
                                `gmv_count`  bigint COMMENT '当日gmv订单个数',
                                `gmv_amount`  decimal(16,2) COMMENT '当日gmv订单总金额',
                                `gmv_payment`  decimal(16,2) COMMENT '当日支付金额'
) COMMENT '每日活跃用户数量'
row format delimited  fields terminated by '\t'
location '/user/hive/warehouse/dev_realtime_yinshi.db/ads/ads_gmv_sum_day/'
;

drop table if exists ads_user_convert_day;
create   table ads_user_convert_day(
                                       `dt` string COMMENT '统计日期',
                                       `uv_m_count`  bigint COMMENT '当日活跃设备',
                                       `new_m_count`  bigint COMMENT '当日新增设备',
                                       `new_m_ratio`   decimal(10,2) COMMENT '当日新增占日活的比率'
) COMMENT '每日活跃用户数量'
row format delimited  fields terminated by '\t'
location '/user/hive/warehouse/dev_realtime_yinshi.db/ads/ads_user_convert_day/'
;

drop table if exists ads_user_action_convert_day;
create   table ads_user_action_convert_day(
                                              `dt` string COMMENT '统计日期',
                                              `total_visitor_m_count`  bigint COMMENT '总访问人数',
                                              `order_u_count` bigint     COMMENT '下单人数',
                                              `visitor2order_convert_ratio`  decimal(10,2) COMMENT '访问到下单转化率',
                                              `payment_u_count` bigint     COMMENT '支付人数',
                                              `order2payment_convert_ratio` decimal(10,2) COMMENT '下单到支付的转化率'
) COMMENT '每日用户行为转化率统计'
row format delimited  fields terminated by '\t'
location '/user/hive/warehouse/dev_realtime_yinshi.db/ads/ads_user_convert_day/'
;

drop table if exists dws_sale_detail_daycount;
create external table  dws_sale_detail_daycount
(  user_id  string  comment '用户 id',
 sku_id  string comment '商品 Id',
 user_gender  string comment '用户性别',
 user_age string  comment '用户年龄',
 user_level string comment '用户等级',
 order_price decimal(10,2) comment '订单价格',
 sku_name string  comment '商品名称',
 sku_tm_id string  comment '品牌id',
 sku_category3_id string comment '商品三级品类id',
 sku_category2_id string comment '商品二级品类id',
 sku_category1_id string comment '商品一级级品类名称',
 sku_category2_name string comment '商品二级品类名称',
sku_category1_name string comment '商品一品类id',
sku_category3_name string comment '商品三级品类名称',
 spu_id  string comment '商品 spu',
 sku_num  int comment '购买个数',
 order_count string comment '当日下单单数',
 order_amount string comment '当日下单金额'
) COMMENT '用户购买商品明细表'
PARTITIONED BY ( `dt` string)
stored as  parquet
location '/user/hive/warehouse/dev_realtime_yinshi.db/dws/dws_user_sale_detail_daycount/'
tblproperties ("parquet.compression"="snappy");

with
    tmp_detail as
        (
            select
                user_id,
                sku_id,
                sum(sku_num) sku_num ,
                count(*) order_count ,
                sum(od.order_price*sku_num)  order_amount
            from ods_order_detail od
            where od.dt='2025-03-23' and user_id is not null
            group by user_id, sku_id
        )
insert overwrite table  dws_sale_detail_daycount partition(dt='2025-03-23')
select
    tmp_detail.user_id,
    tmp_detail.sku_id,
    u.gender,
    months_between('2025-03-23', u.birthday)/12  age,
    u.user_level,
    price,
    sku_name,
    tm_id,
    category3_id ,
    category2_id ,
    category1_id ,
    category3_name ,
    category2_name ,
    category1_name ,
    spu_id,
    tmp_detail.sku_num,
    tmp_detail.order_count,
    tmp_detail.order_amount
from tmp_detail
         left join dwd_user_info u on u.id=tmp_detail.user_id  and u.dt='2025-03-23'
         left join dwd_sku_info s on tmp_detail.sku_id =s.id  and s.dt='2025-03-23'
;

drop  table ads_sale_tm_category1_stat_mn;
create  table ads_sale_tm_category1_stat_mn
(
    tm_id string comment '品牌id ' ,
    category1_id string comment '1级品类id ',
    category1_name string comment '1级品类名称 ',
    buycount   bigint comment  '购买人数',
    buy_twice_last bigint  comment '两次以上购买人数',
    buy_twice_last_ratio decimal(10,2)  comment  '单次复购率',
    buy_3times_last   bigint comment   '三次以上购买人数',
    buy_3times_last_ratio decimal(10,2)  comment  '多次复购率' ,
    stat_mn string comment '统计月份',
    stat_date string comment '统计日期'
)   COMMENT '复购率统计'
row format delimited  fields terminated by '\t'
location '/user/hive/warehouse/dev_realtime_yinshi.db/ads/ads_sale_tm_category1_stat_mn/'
;

insert into table ads_sale_tm_category1_stat_mn
select
    mn.sku_tm_id,
    mn.sku_category1_id,
    mn.sku_category1_name,
    sum(if(mn.order_count>=1,1,0)) buycount,
    sum(if(mn.order_count>=2,1,0)) buyTwiceLast,
    sum(if(mn.order_count>=2,1,0))/sum( if(mn.order_count>=1,1,0)) buyTwiceLastRatio,
    sum(if(mn.order_count>3,1,0))  buy3timeLast  ,
    sum(if(mn.order_count>=3,1,0))/sum( if(mn.order_count>=1,1,0)) buy3timeLastRatio ,
    date_format('2025-03-23' ,'yyyy-MM') stat_mn,
    '2025-03-23' stat_date
from
    (
        select od.sku_tm_id,
               od.sku_category1_id,
               od.sku_category1_name,
               user_id ,
               sum(order_count) order_count
        from  dws_sale_detail_daycount  od
        where
                date_format(dt,'yyyy-MM')<=date_format('2025-03-23' ,'yyyy-MM')
        group by
            od.sku_tm_id, od.sku_category1_id, user_id, od.sku_category1_name
    ) mn
group by mn.sku_tm_id, mn.sku_category1_id, mn.sku_category1_name
;