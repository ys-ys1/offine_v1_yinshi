import xbot
from xbot import print, sleep
from .package import variables as glv
import time
import pymysql
import re
import unicodedata
from xbot import web
import random


def main(submitter):
    mydb = None
    mycursor = None
    web_page = None

    try:
        # 创建数据库连接
        mydb = pymysql.connect(
            host="43.143.30.32",
            port=3306,
            user="yingdao",
            password="9527",
            database="ydtest",
            charset='utf8'
        )
        mycursor = mydb.cursor()

        # SQL插入语句，使用参数化查询
        sql = """
        INSERT INTO movie (电影名称, 上映年份, 制片地区, 评分, 导演, 票房, 提交人)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
        """

        # 打开首页
        web_page = xbot.web.create(url="http://www.boxofficecn.com/the-red-box-office")
        random_sleep()

        while True:
            # 获取所有电影行元素
            movie_rows = web_page.find_all_by_xpath('//table/tbody/tr')

            for row in movie_rows:
                try:
                    # 电影名称和评分在同一文本中，提取评分
                    movie_name_score = row.find_by_xpath('./td[2]').get_text().strip()
                    # 将全角字符转换为半角字符
                    movie_name_score = unicodedata.normalize('NFKC', movie_name_score)
                    movie_name = movie_name_score.split('(')[0].strip()
                    score_text = movie_name_score.split('(')[-1].rstrip(')')
                    try:
                        score = float(score_text) if score_text else 0
                    except ValueError as ve:
                        print(f"处理电影 {movie_name} 评分转换出错，错误信息: {ve}")
                        score = 0

                    # 上映年份
                    release_year = row.find_by_xpath('./td[1]').get_text().strip()

                    # 制片地区
                    flag_element = row.find_by_xpath('./td[1]/img')
                    if flag_element:
                        flag_src = flag_element.get_attribute('src')
                        if "1f1e8-1f1f3" in flag_src:  # 中国国旗相关特征
                            production_area = "中国"
                        elif "1f1fa-1f1f8" in flag_src:  # 美国国旗相关特征
                            production_area = "美国"
                        elif "1f1ef-1f1f5" in flag_src:  # 日本国旗相关特征
                            production_area = "日本"
                        else:
                            production_area = "其他"
                    else:
                        production_area = "未知"

                    # 导演
                    director = row.find_by_xpath('./td[3]').get_text().strip()

                    # 票房
                    box_office_text = row.find_by_xpath('./td[4]').get_text().strip()
                    clean_box_office = re.sub(r'[^\d.]|[\u2192]|[\&]', '', box_office_text)
                    box_office = float(clean_box_office) if clean_box_office else 0

                    data = (movie_name, release_year, production_area, score, director, box_office, submitter)

                    # 插入数据到数据库
                    mycursor.execute(sql, data)
                    mydb.commit()
                    print("数据插入成功:", data)
                except Exception as e:
                    print(f"处理电影 {movie_name} 时出错，错误信息: {e}")
                    mydb.rollback()

            # 尝试点击下一页按钮
            next_page_btn = web_page.find_by_xpath('//a[@id="tablepress-4_next"]')
            if next_page_btn and 'disabled' not in next_page_btn.get_attribute('class'):
                try:
                    next_page_btn.click()
                    random_sleep()
                except Exception as click_err:
                    print(f"点击下一页按钮失败: {click_err}")
                    break
            else:
                print('未找到下一页元素，结束执行')
                break

        # 关闭首页浏览器
        if web_page is not None:
            web_page.close()

    except Exception as e:
        print(f"程序发生错误: {e}")
    finally:
        # 关闭数据库连接
        if mycursor is not None:
            mycursor.close()
        if mydb is not None:
            mydb.close()
        web.close_all('cef')  # 确保所有CEF浏览器实例都被关闭


def random_sleep():
    sleep(random.uniform(5, 10))