# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://doc.scrapy.org/en/latest/topics/item-pipeline.html
from scrapy.exporters import JsonItemExporter
import codecs
import json

class IshadowPipeline(object):
    # def __init__(self):
    #     self.file = open('ishadow.json', 'wb')
    #     self.exporter = JsonItemExporter(self.file, encoding="utf-8", ensure_ascii=False)
    #     self.exporter.start_exporting()
    #
    # def process_item(self, item, spider):
    #     self.exporter.export_item(item)
    #     return item
    #
    # def close_spider(self, spider):  # 关闭文件
    #     self.exporter.finish_exporting()
    #     self.file.close()

    def __init__(self):
        self.file = codecs.open('ishadow.json', 'w', encoding='utf-8')
        self.file.write('[\n')

    def process_item(self, item, spider):
        lines = json.dumps(dict(item), ensure_ascii=False) + ",\n"
        self.file.write(lines)
        return item

    def close_spider(self, spider):
        self.file.write(']')
        self.file.close()