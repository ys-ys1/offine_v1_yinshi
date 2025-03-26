import xbot
from xbot import print, sleep
from .package import variables as glv
import time
import pymysql
import re
from xbot import web
import random


def get_directors(web_dg):
    """获取导演信息，如果有多个导演，使用英文逗号分隔"""
    directors = []
    try:
        director_elements = web_dg.find_all_by_xpath('//a[@rel="v:directedBy"]')
        for element in director_elements:
            if element and element.get_text():
                directors.append(element.get_text().strip())
    except Exception as e:
        print(f"获取导演信息时发生错误: {e}")
    return ', '.join(directors)


def format_data(data):
    """格式化数据以符合数据库字段类型"""
    name, release_year, production_area, score, director, box_office, submitter = data

    # 转换数据类型
    try:
        release_year = int(release_year)
    except (ValueError, TypeError):
        release_year = 0  # 或者其他默认值

    # 处理票房单位，这里假设数据库存储的是元，网页数据单位是万元
    if isinstance(box_office, str):
        box_office = box_office.strip()
        try:
            box_office = int(float(box_office) * 10000)
        except (ValueError, TypeError):
            box_office = 0  # 或者其他默认值
    else:
        box_office = 0  # 如果不是字符串，默认设置为0

    try:
        score = float(score)
    except (ValueError, TypeError):
        score = 0.0  # 或者其他默认值

    return (name, release_year, production_area, score, director, box_office, submitter)


def main(submitter):
    mydb = None
    mycursor = None
    web_page = None
    web_dg = None

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
            # 获取当前页的所有电影链接
            movie_links = web_page.find_all_by_xpath('//table/tbody/tr/td[2]/a')
            for link in movie_links:
                if not link:
                    continue
                movie_url = link.get_attribute('href')
                if "douban.com" not in movie_url:
                    continue  # 只处理豆瓣链接，跳过非豆瓣的链接
                retry_count = 3
                for _ in range(retry_count):
                    try:
                        web_dg = xbot.web.create(url=movie_url)
                        break
                    except:
                        if _ == retry_count - 1:
                            print(f"打开{link.get_text()}的豆瓣页面失败，已超过重试次数")
                            continue
                        else:
                            sleep(5)
                try:
                    # 从豆瓣页面获取电影名称
                    try:
                        name_element = web_dg.find_by_xpath('//div[@id="content"]/h1/span[1]')
                        name = name_element.get_text() if name_element else ''
                    except:
                        name = ''
                        print(f"获取{link.get_text()}的电影名称失败，已跳过")
                        continue

                    # 从豆瓣页面获取导演
                    try:
                        director = get_directors(web_dg)
                    except:
                        director = ''
                        print(f"获取{link.get_text()}的导演信息失败，已跳过")

                    # 从豆瓣页面获取评分
                    try:
                        score_element = web_dg.find_by_xpath('//strong[@class="ll rating_num"]')
                        score = score_element.get_text().strip() if score_element else ''
                    except:
                        score = ''
                        print(f"获取{link.get_text()}的评分信息失败，已跳过")

                    # 从首页获取年份和票房
                    year_xpath = f'//table/tbody/tr[contains(td[2]/a, "{link.get_text()}")]/td[1]'
                    year_elements = web_page.find_all_by_xpath(year_xpath)
                    if year_elements:
                        year_text = year_elements[0].get_text() if year_elements[0] else ''
                        release_year = re.search(r'\d+', year_text).group() if re.search(r'\d+', year_text) else ''
                    else:
                        release_year = ''
                        print(f"获取{link.get_text()}的年份信息失败，使用的XPath: {year_xpath}，未找到匹配元素")

                    box_office_xpath = f'//table/tbody/tr[contains(td[2]/a, "{link.get_text()}")]/td[4]'
                    box_office_elements = web_page.find_all_by_xpath(box_office_xpath)
                    if box_office_elements:
                        box_office = box_office_elements[0].get_text() if box_office_elements[0] else ''
                    else:
                        box_office = ''
                        print(f"获取{link.get_text()}的票房信息失败，使用的XPath: {box_office_xpath}，未找到匹配元素")

                    # 制片地区暂时设置为空，若要获取可补充逻辑
                    production_area = ''

                    data = (name, release_year, production_area, score, director, box_office, submitter)
                    formatted_data = format_data(data)

                    # 插入数据到数据库
                    try:
                        mycursor.execute(sql, formatted_data)
                        mydb.commit()
                        print("数据插入成功:", formatted_data)
                    except Exception as e:
                        mydb.rollback()
                        print(f"发生数据库插入错误: {e}, 数据: {formatted_data}")
                finally:
                    if web_dg is not None:
                        web_dg.close()  # 关闭当前电影详情页

            # 尝试点击下一页按钮
            next_page_btn = web_page.find_by_xpath('//a[@class="layui-laypage-next"]')
            if next_page_btn and 'layui-disabled' not in next_page_btn.get_attribute('class'):
                next_page_btn.click()
                random_sleep()
                try:
                    from selenium.webdriver.support.ui import WebDriverWait
                    from selenium.webdriver.support import expected_conditions as EC
                    from selenium.webdriver.common.by import By
                    wait = WebDriverWait(web_page.driver, 20)
                    wait.until(EC.presence_of_all_elements_located((By.XPATH, '//table/tbody/tr/td[2]/a')))
                except:
                    print("等待下一页电影链接加载超时")
                    break
            else:
                print('未找到下一页元素，结束执行')
                break

    except Exception as e:
        print(f"程序发生错误: {e}")
    finally:
        # 关闭数据库连接
        if mycursor is not None:
            mycursor.close()
        if mydb is not None:
            mydb.close()
        # 确保关闭所有打开的浏览器窗口
        if web_page is not None:
            web_page.close()
        web.close_all('cef')  # 确保所有CEF浏览器实例都被关闭


def random_sleep():
    sleep(random.uniform(5, 10))
