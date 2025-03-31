
-- 用户行为日志表
drop table ods_user_behavior_log;
CREATE TABLE IF NOT EXISTS ods_user_behavior_log (
                                                     log_id STRING COMMENT '日志ID',
                                                     user_id STRING COMMENT '用户ID',
                                                     product_id STRING COMMENT '商品ID',
                                                     shop_id STRING COMMENT '店铺ID',
                                                     behavior_type STRING COMMENT '行为类型，如访问、收藏、加购等',
                                                     behavior_time TIMESTAMP COMMENT '行为发生时间'
) COMMENT '用户行为日志表'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    STORED AS TEXTFILE;

INSERT INTO ods_user_behavior_log
SELECT
    concat('log_', cast(id as string)) as log_id,
    concat('user_', cast(floor(rand() * 10) as string)) as user_id,
    concat('product_', cast(floor(rand() * 10) as string)) as product_id,
    concat('shop_', cast(floor(rand() * 5) as string)) as shop_id,
    case floor(rand() * 3)
        when 0 then '访问'
        when 1 then '收藏'
        when 2 then '加购'
        end as behavior_type,
    from_unixtime(unix_timestamp(concat('2025-01-', cast(floor(rand() * 31) + 1 as string), ' ',
                                        lpad(cast(floor(rand() * 24) as string), 2, '0'), ':',
                                        lpad(cast(floor(rand() * 60) as string), 2, '0'), ':',
                                        lpad(cast(floor(rand() * 60) as string), 2, '0'))), 'yyyy-MM-dd HH:mm:ss') as behavior_time
FROM (
         SELECT posexplode(split(repeat('a', 100), 'a')) as (id, dummy)
     ) t;

-- 商品信息表
drop table ods_product_info;
CREATE TABLE IF NOT EXISTS ods_product_info (
                                                product_id STRING COMMENT '商品ID',
                                                product_name STRING COMMENT '商品名称',
                                                price DECIMAL(10, 2) COMMENT '商品价格',
    shop_id STRING COMMENT '所属店铺ID',
    product_category STRING COMMENT '商品分类'
    ) COMMENT '商品信息表'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    STORED AS TEXTFILE;

INSERT INTO ods_product_info
SELECT
    concat('product_', cast(id as string)) as product_id,
    concat('商品_', cast(id as string)) as product_name,
    round(rand() * 1000, 2) as price,
    concat('shop_', cast(floor(rand() * 7) as string)) as shop_id,
    case floor(rand() * 3)
        when 0 then '电子产品'
        when 1 then '服装'
        when 2 then '食品'
        end as product_category
FROM (
         SELECT posexplode(split(repeat('a', 100), 'a')) as (id, dummy)
     ) t;

-- 订单信息表
drop table ods_order_info;
CREATE TABLE IF NOT EXISTS ods_order_info (
                                              order_id STRING COMMENT '订单ID',
                                              user_id STRING COMMENT '用户ID',
                                              product_id STRING COMMENT '商品ID',
                                              order_time TIMESTAMP COMMENT '下单时间',
                                              order_amount DECIMAL(10, 2) COMMENT '下单金额',
    payment_time TIMESTAMP COMMENT '支付时间',
    payment_amount DECIMAL(10, 2) COMMENT '支付金额',
    refund_amount DECIMAL(10, 2) COMMENT '退款退货金额'
    ) COMMENT '订单信息表'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    STORED AS TEXTFILE;

INSERT INTO ods_order_info
SELECT
    concat('order_', cast(id as string)) as order_id,
    concat('user_', cast(floor(rand() * 10) as string)) as user_id,
    concat('product_', cast(floor(rand() * 10) as string)) as product_id,
    from_unixtime(unix_timestamp(concat('2025-01-', cast(floor(rand() * 31) + 1 as string), ' ',
                                        lpad(cast(floor(rand() * 24) as string), 2, '0'), ':',
                                        lpad(cast(floor(rand() * 60) as string), 2, '0'), ':',
                                        lpad(cast(floor(rand() * 60) as string), 2, '0'))), 'yyyy-MM-dd HH:mm:ss') as order_time,
    round(rand() * 1000, 2) as order_amount,
    from_unixtime(unix_timestamp(concat('2025-01-', cast(floor(rand() * 31) + 1 as string), ' ',
                                        lpad(cast(floor(rand() * 24) as string), 2, '0'), ':',
                                        lpad(cast(floor(rand() * 60) as string), 2, '0'), ':',
                                        lpad(cast(floor(rand() * 60) as string), 2, '0'))), 'yyyy-MM-dd HH:mm:ss') as payment_time,
    round(rand() * 1000, 2) as payment_amount,
    round(rand() * 100, 2) as refund_amount
FROM (
         SELECT posexplode(split(repeat('a', 100), 'a')) as (id, dummy)
     ) t;

-- 用户信息表
drop  table  ods_user_info;
CREATE TABLE IF NOT EXISTS ods_user_info (
                                             user_id STRING COMMENT '用户ID',
                                             user_type STRING COMMENT '用户类型，如新用户、老用户'
) COMMENT '用户信息表'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    STORED AS TEXTFILE;

INSERT INTO ods_user_info
SELECT
    concat('user_', cast(id as string)) as user_id,
    case floor(rand() * 2)
        when 0 then '新用户'
        when 1 then '老用户'
        end as user_type
FROM (
         SELECT posexplode(split(repeat('a', 100), 'a')) as (id, dummy)
     ) t;

-- 店铺信息表
drop  table  ods_shop_info;
CREATE TABLE IF NOT EXISTS ods_shop_info (
                                             shop_id STRING COMMENT '店铺ID',
                                             shop_name STRING COMMENT '店铺名称'
) COMMENT '店铺信息表'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    STORED AS TEXTFILE;

INSERT INTO ods_shop_info
SELECT
    concat('shop_', cast(id as string)) as shop_id,
    concat('店铺_', cast(id as string)) as shop_name
FROM (
         SELECT posexplode(split(repeat('a', 100), 'a')) as (id, dummy)
     ) t;

-- 创建 DWS 层商品宏观监控表，按照店铺、商品和时间周期聚合数据
drop table dws_product_macro_monitoring;
CREATE TABLE IF NOT EXISTS dws_product_macro_monitoring (
                                                            shop_id STRING COMMENT '店铺 ID',
                                                            product_id STRING COMMENT '商品 ID',
                                                            time_period STRING COMMENT '时间周期，如 7d, 30d, day',
                                                            visit_count INT COMMENT '访问次数',
                                                            collect_count INT COMMENT '收藏人数',
                                                            add_to_cart_count INT COMMENT '加购人数',
                                                            add_to_cart_items INT COMMENT '加购件数',
                                                            sales_count INT COMMENT '销售件数',
                                                            sales_amount DECIMAL(10, 2) COMMENT '销售金额',
    active_sales_count INT COMMENT '动销商品数',
    collect_add_to_cart_count INT COMMENT '收藏加购总人数',
    payment_conversion_rate DECIMAL(5, 2) COMMENT '支付转化率',
    price_range STRING COMMENT '商品价格区间，如 100 - 500, 501 - 1000 等',
    average_unit_price DECIMAL(10, 2) COMMENT '件单价（均价）',
    product_visitor_count INT COMMENT '商品访客数',
    product_view_count INT COMMENT '商品浏览量',
    visited_product_count INT COMMENT '有访问商品数',
    average_stay_time DECIMAL(5, 2) COMMENT '商品平均停留时长（分钟）',
    product_detail_bounce_rate DECIMAL(5, 2) COMMENT '商品详情页跳出率',
    visit_collect_conversion_rate DECIMAL(5, 2) COMMENT '访问收藏转化率',
    visit_add_to_cart_conversion_rate DECIMAL(5, 2) COMMENT '访问加购转化率',
    order_buyer_count INT COMMENT '下单买家数',
    order_item_count INT COMMENT '下单件数',
    order_amount DECIMAL(10, 2) COMMENT '下单金额',
    order_conversion_rate DECIMAL(5, 2) COMMENT '下单转化率',
    payment_buyer_count INT COMMENT '支付买家数',
    payment_item_count INT COMMENT '支付件数',
    payment_new_buyer_count INT COMMENT '支付新买家数',
    payment_old_buyer_count INT COMMENT '支付老买家数',
    old_buyer_payment_amount DECIMAL(10, 2) COMMENT '老买家支付金额',
    customer_unit_price DECIMAL(10, 2) COMMENT '客单价',
    successful_refund_amount DECIMAL(10, 2) COMMENT '成功退款退货金额',
    annual_accumulated_payment_amount DECIMAL(10, 2) COMMENT '年累计支付金额',
    visitor_average_value DECIMAL(10, 2) COMMENT '访客平均价值',
    competitiveness_score DECIMAL(5, 2) COMMENT '竞争力评分',
    product_micro_detail_visitor_count INT COMMENT '商品微详情访客数'
    ) COMMENT 'DWS 层商品宏观监控表'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    STORED AS TEXTFILE;

INSERT INTO dws_product_macro_monitoring
SELECT
    pi.shop_id,
    pi.product_id,
    DATE_FORMAT(ub.behavior_time, 'yyyy-MM-dd') AS time_period,
    COUNT(CASE WHEN ub.behavior_type = '访问' THEN 1 END) AS visit_count,
    COUNT(CASE WHEN ub.behavior_type = '收藏' THEN 1 END) AS collect_count,
    COUNT(CASE WHEN ub.behavior_type = '加购' THEN 1 END) AS add_to_cart_count,
    SUM(CASE WHEN ub.behavior_type = '加购' THEN 1 END) AS add_to_cart_items,
    COUNT(CASE WHEN oi.order_amount > 0 THEN 1 END) AS sales_count,
    SUM(oi.order_amount) AS sales_amount,
    COUNT(DISTINCT CASE WHEN oi.order_amount > 0 THEN pi.product_id END) AS active_sales_count,
    COUNT(CASE WHEN ub.behavior_type IN ('收藏', '加购') THEN 1 END) AS collect_add_to_cart_count,
    -- 支付转化率 = 支付买家数 / 访问人数
    COUNT(CASE WHEN ub.behavior_type = '支付' THEN 1 END) /
    NULLIF(COUNT(CASE WHEN ub.behavior_type = '访问' THEN 1 END), 0) AS payment_conversion_rate,
    CASE
        WHEN pi.price >= 100 AND pi.price <= 500 THEN '100 - 500'
        WHEN pi.price >= 501 AND pi.price <= 1000 THEN '501 - 1000'
        WHEN pi.price >= 1001 AND pi.price <= 5000 THEN '1001 - 5000'
        WHEN pi.price > 5000 THEN '>5000'
        ELSE '其他'
        END AS price_range,
    -- 件单价（均价）= 销售金额 / 销售件数
    SUM(oi.order_amount) /
    NULLIF(COUNT(CASE WHEN oi.order_amount > 0 THEN 1 END), 0) AS average_unit_price,
    COUNT(DISTINCT CASE WHEN ub.behavior_type = '访问' THEN ub.user_id END) AS product_visitor_count,
    COUNT(CASE WHEN ub.behavior_type = '访问' THEN 1 END) AS product_view_count,
    COUNT(DISTINCT ub.product_id) AS visited_product_count,
    12.00 AS average_stay_time,
    0.21 AS product_detail_bounce_rate,
    -- 访问收藏转化率 = 收藏人数 / 访问人数
    COUNT(CASE WHEN ub.behavior_type = '收藏' THEN 1 END) /
    NULLIF(COUNT(CASE WHEN ub.behavior_type = '访问' THEN 1 END), 0) AS visit_collect_conversion_rate,
    -- 访问加购转化率 = 加购人数 / 访问人数
    COUNT(CASE WHEN ub.behavior_type = '加购' THEN 1 END) /
    NULLIF(COUNT(CASE WHEN ub.behavior_type = '访问' THEN 1 END), 0) AS visit_add_to_cart_conversion_rate,
    COUNT(DISTINCT CASE WHEN oi.order_amount > 0 THEN oi.user_id END) AS order_buyer_count,
    COUNT(CASE WHEN oi.order_amount > 0 THEN 1 END) AS order_item_count,
    SUM(oi.order_amount) AS order_amount,
    -- 下单转化率 = 下单买家数 / 访问人数
    COUNT(DISTINCT CASE WHEN oi.order_amount > 0 THEN oi.user_id END) /
    NULLIF(COUNT(CASE WHEN ub.behavior_type = '访问' THEN 1 END), 0) AS order_conversion_rate,
    COUNT(DISTINCT CASE WHEN oi.payment_amount > 0 THEN oi.user_id END) AS payment_buyer_count,
    COUNT(CASE WHEN oi.payment_amount > 0 THEN 1 END) AS payment_item_count,
    COUNT(DISTINCT CASE WHEN oi.payment_amount > 0 AND ui.user_type = '新用户' THEN oi.user_id END) AS payment_new_buyer_count,
    COUNT(DISTINCT CASE WHEN oi.payment_amount > 0 AND ui.user_type = '老用户' THEN oi.user_id END) AS payment_old_buyer_count,
    SUM(CASE WHEN oi.payment_amount > 0 AND ui.user_type = '老用户' THEN oi.payment_amount END) AS old_buyer_payment_amount,
    -- 客单价 = 支付金额 / 支付买家数
    SUM(oi.payment_amount) /
    NULLIF(COUNT(DISTINCT CASE WHEN oi.payment_amount > 0 THEN oi.user_id END), 0) AS customer_unit_price,
    SUM(oi.refund_amount) AS successful_refund_amount,
    SUM(oi.payment_amount) AS annual_accumulated_payment_amount,
    -- 访客平均价值 = 支付金额 / 访问人数
    SUM(oi.payment_amount) /
    NULLIF(COUNT(CASE WHEN ub.behavior_type = '访问' THEN 1 END), 0) AS visitor_average_value,
    70.00 AS competitiveness_score,
    80 AS product_micro_detail_visitor_count
FROM
    ods_product_info pi
        JOIN
    ods_user_behavior_log ub ON pi.product_id = ub.product_id
        JOIN
    ods_order_info oi ON pi.product_id = oi.product_id AND ub.user_id = oi.user_id
        JOIN
    ods_user_info ui ON ub.user_id = ui.user_id
GROUP BY
    pi.shop_id,
    pi.product_id,
    DATE_FORMAT(ub.behavior_time, 'yyyy-MM-dd'),
    pi.price
ORDER BY
    pi.shop_id,
    pi.product_id;























