import xbot
from xbot import print, sleep
from .import package
from .package import variables as glv
from collections import defaultdict
import pymysql
import requests
import os  # 引入os模块用于设置环境变量


def one():
    try:
        os.environ['NO_PROXY'] = "mock.jsont.run"  # 设置不使用代理访问该域名
        # 修改此处的网页地址为新的地址
        m = requests.get('https://mock.jsont.run/6zA7NH6ciqxNxGYzKO-Zx').json()
        data = m['data']
        country_box_office = defaultdict(float)
        for movie in data:
            country = movie.get("制片地区", "")
            box_office = float(movie.get("票房", 0.0))
            country_box_office[country] += box_office

        top_countries = sorted(country_box_office.items(), key=lambda x: x[1], reverse=True)[:3]
        data_to_insert = [('殷实', country, total_box_office) for country, total_box_office in top_countries]
        print(data_to_insert)

        db_config = {
            'host': '43.143.30.32',
            'port': 3306,
            'user': 'yingdao',
            'password': '9527',
            'database': 'ydtest',
            'charset': 'utf8mb4'
        }

        connection = pymysql.connect(**db_config)
        with connection.cursor() as cursor:
            sql = "INSERT INTO result (提交人, 信息, 票房总数) VALUES (%s, %s, %s)"
            cursor.executemany(sql, data_to_insert)
            connection.commit()
        connection.close()
    except Exception as e:
        print(f"其他错误: {e}")


def two():
    try:
        os.environ['NO_PROXY'] = "mock.jsont.run"  # 设置不使用代理访问该域名
        # 修改此处的网页地址为新的地址
        m = requests.get('https://mock.jsont.run/6zA7NH6ciqxNxGYzKO-Zx').json()
        data = m['data']
        rating_intervals = {
            "3.0 - 3.5": 0.0,
            "9.0 - 9.5": 0.0,
            "无评分": 0.0
        }
        for movie in data:
            box_office_str = movie.get("票房", "0.0")
            box_office = float(box_office_str) if box_office_str != '-' else 0.0
            rating = movie.get("评分", None)
            if rating == '-':
                pass
            else:
                rating = float(rating)
                if rating is None:
                    rating_intervals["无评分"] += box_office
                elif 3.0 <= rating < 3.5:
                    rating_intervals["3.0 - 3.5"] += box_office
                elif 9.0 <= rating < 9.5:
                    rating_intervals["9.0 - 9.5"] += box_office

        data_to_insert = [('殷实', interval, total_box_office) for interval, total_box_office in rating_intervals.items()]
        print(data_to_insert)

        db_config = {
            'host': '43.143.30.32',
            'port': 3306,
            'user': 'yingdao',
            'password': '9527',
            'database': 'ydtest',
            'charset': 'utf8mb4'
        }

        connection = pymysql.connect(**db_config)
        with connection.cursor() as cursor:
            sql = "INSERT INTO result (提交人, 信息, 票房总数) VALUES (%s, %s, %s)"
            cursor.executemany(sql, data_to_insert)
            connection.commit()
        connection.close()
    except Exception as e:
        print(f"其他错误: {e}")


def main(args):
    one()
    two()