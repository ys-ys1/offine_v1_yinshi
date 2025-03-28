

use ys;

CREATE TABLE product_core_trend (
                                    id INT AUTO_INCREMENT PRIMARY KEY,
                                    product_id VARCHAR(50) NOT NULL COMMENT '商品ID',
                                    record_date DATE NOT NULL COMMENT '记录日期',
                                    sales_volume INT COMMENT '销量',
                                    sales_amount DECIMAL(10, 2) COMMENT '销售额',
                                    click_count INT COMMENT '点击量',
                                    operation_action VARCHAR(100) COMMENT '运营行动（如新客折扣报名等）'
) COMMENT '商品核心数据趋势表';

INSERT INTO product_core_trend (product_id, record_date, sales_volume, sales_amount, click_count, operation_action)
VALUES
    ('P001', '2025-01-01', 10, 100.00, 50, '报名新客折扣'),
    ('P001', '2025-01-02', 12, 120.00, 60, NULL),
    ('P002', '2025-01-01', 8, 80.00, 40, '发布短视频');

CREATE TABLE sku_sales_detail (
                                  id INT AUTO_INCREMENT PRIMARY KEY,
                                  sku_id VARCHAR(50) NOT NULL COMMENT 'SKU ID',
                                  product_id VARCHAR(50) NOT NULL COMMENT '商品ID',
                                  sales_volume INT COMMENT '销量',
                                  sales_amount DECIMAL(10, 2) COMMENT '销售额',
                                  attribute_value VARCHAR(100) COMMENT '属性值（如颜色、尺寸等）',
                                  hot_sell_level INT COMMENT '热销程度，数值越大越热销'
) COMMENT 'SKU销售详情表';

-- 插入模拟数据
INSERT INTO sku_sales_detail (sku_id, product_id, sales_volume, sales_amount, attribute_value, hot_sell_level)
VALUES
    ('SKU001', 'P001', 5, 50.00, '红色, M', 3),
    ('SKU002', 'P001', 3, 30.00, '蓝色, L', 2),
    ('SKU003', 'P002', 4, 40.00, '黑色, S', 2);

CREATE TABLE traffic_channel_analysis (
                                          id INT AUTO_INCREMENT PRIMARY KEY,
                                          product_id VARCHAR(50) NOT NULL COMMENT '商品ID',
                                          channel_name VARCHAR(50) NOT NULL COMMENT '流量渠道名称（如淘宝搜索、直通车等）',
                                          visitor_count INT COMMENT '访客数',
                                          conversion_count INT COMMENT '转化数',
                                          conversion_rate DECIMAL(5, 2) COMMENT '转化率'
) COMMENT '流量渠道分析表';

-- 插入模拟数据
INSERT INTO traffic_channel_analysis (product_id, channel_name, visitor_count, conversion_count, conversion_rate)
VALUES
    ('P001', '淘宝搜索', 100, 10, 0.10),
    ('P001', '直通车', 80, 8, 0.10),
    ('P002', '淘宝搜索', 80, 8, 0.10);


CREATE TABLE product_price_power (
                                     id INT AUTO_INCREMENT PRIMARY KEY,
                                     product_id VARCHAR(50) NOT NULL COMMENT '商品ID',
                                     price_power_star INT COMMENT '价格力星级',
                                     core_index DECIMAL(10, 2) COMMENT '商品力核心指标',
                                     market_same_index DECIMAL(10, 2) COMMENT '市场同类目同价格带同星级优秀商品力指标',
                                     category_rank INT COMMENT '同类目价格力商品榜单排名'
) COMMENT '商品价格力表';

-- 插入模拟数据
INSERT INTO product_price_power (product_id, price_power_star, core_index, market_same_index, category_rank)
VALUES
    ('P001', 3, 0.6, 0.7, 10),
    ('P002', 2, 0.5, 0.6, 15),
    ('P003', 3, 0.65, 0.75, 8);


CREATE TABLE price_trend (
                             id INT AUTO_INCREMENT PRIMARY KEY,
                             product_id VARCHAR(50) NOT NULL COMMENT '商品ID',
                             record_date DATE NOT NULL COMMENT '记录日期',
                             price DECIMAL(10, 2) COMMENT '商品价格',
                             traffic_volume INT COMMENT '流量',
                             transaction_count INT COMMENT '成交量'
) COMMENT '价格趋势表';

-- 插入模拟数据
INSERT INTO price_trend (product_id, record_date, price, traffic_volume, transaction_count)
VALUES
    ('P001', '2025-01-01', 10.00, 50, 10),
    ('P001', '2025-01-02', 10.50, 45, 8),
    ('P002', '2025-01-01', 8.00, 40, 8);

CREATE TABLE title_root_word_analysis (
                                          id INT AUTO_INCREMENT PRIMARY KEY,
                                          product_id VARCHAR(50) NOT NULL COMMENT '商品ID',
                                          root_word VARCHAR(50) NOT NULL COMMENT '词根',
                                          traffic_count INT COMMENT '引流人数',
                                          conversion_count INT COMMENT '转化数',
                                          conversion_rate DECIMAL(5, 2) COMMENT '转化率'
) COMMENT '标题词根分析表';

-- 插入模拟数据
INSERT INTO title_root_word_analysis (product_id, root_word, traffic_count, conversion_count, conversion_rate)
VALUES
    ('P001', '时尚', 30, 3, 0.10),
    ('P001', '休闲', 20, 2, 0.10),
    ('P002', '运动', 25, 2, 0.08);

CREATE TABLE single_product_content_data (
                                             id INT AUTO_INCREMENT PRIMARY KEY,
                                             product_id VARCHAR(50) NOT NULL COMMENT '商品ID',
                                             content_type VARCHAR(20) NOT NULL COMMENT '内容类型（直播、短视频、图文）',
                                             content_id VARCHAR(50) COMMENT '内容ID',
                                             view_count INT COMMENT '观看量',
                                             interaction_count INT COMMENT '互动量（点赞、评论等）'
) COMMENT '单品内容数据表';

-- 插入模拟数据
INSERT INTO single_product_content_data (product_id, content_type, content_id, view_count, interaction_count)
VALUES
    ('P001', '直播', 'L001', 100, 20),
    ('P001', '短视频', 'V001', 80, 15),
    ('P002', '图文', 'T001', 60, 10);

CREATE TABLE customer_group_portrait (
                                         id INT AUTO_INCREMENT PRIMARY KEY,
                                         product_id VARCHAR(50) NOT NULL COMMENT '商品ID',
                                         behavior_type VARCHAR(20) NOT NULL COMMENT '行为类型（搜索、访问、支付）',
                                         age_group VARCHAR(20) COMMENT '年龄层',
                                         gender VARCHAR(10) COMMENT '性别',
                                         consumption_level DECIMAL(10, 2) COMMENT '消费层级'
) COMMENT '客群画像表';

-- 插入模拟数据
INSERT INTO customer_group_portrait (product_id, behavior_type, age_group, gender, consumption_level)
VALUES
    ('P001', '搜索', '25 - 34岁', '男', 100.00),
    ('P001', '访问', '35 - 44岁', '女', 120.00),
    ('P002', '支付', '25 - 34岁', '男', 80.00);

CREATE TABLE product_evaluation (
                                    id INT AUTO_INCREMENT PRIMARY KEY,
                                    product_id VARCHAR(50) NOT NULL COMMENT '商品ID',
                                    sku_id VARCHAR(50) COMMENT 'SKU ID',
                                    evaluation_date DATE NOT NULL COMMENT '评价日期',
                                    score INT COMMENT '评分',
                                    comment_text TEXT COMMENT '评价内容',
                                    buyer_type VARCHAR(20) COMMENT '买家类型（整体、老买家等）'
) COMMENT '商品评价表';

-- 插入模拟数据
INSERT INTO product_evaluation (product_id, sku_id, evaluation_date, score, comment_text, buyer_type)
VALUES
    ('P001', 'SKU001', '2025-01-01', 4, '质量不错', '整体'),
    ('P001', 'SKU002', '2025-01-02', 3, '颜色和图片有差异', '整体'),
    ('P002', 'SKU003', '2025-01-01', 4, '很喜欢', '老买家');














































