# -*- coding: utf-8 -*-
import scrapy
from ishadow.items import IshadowItem


class IshadowSpiderSpider(scrapy.Spider):
    name = 'ishadow_spider'
    allowed_domains = ['https://d.ishadowx.com']
    start_urls = ['https://d.ishadowx.com/']

    def parse(self, response):
        account_list = response.xpath('//*[@id="portfolio"]/div[2]/div[2]/div/div')
        for account in account_list:
            account_item = IshadowItem()
            account_item['address']= account.xpath('.//div/div/div/h4[1]/span/text()').extract_first()
            account_item['port'] =account.xpath('.//div/div/div/h4[2]/span/text()').extract_first().strip()
            account_item['password'] =account.xpath('.//div/div/div/h4[3]/span/text()').extract_first().strip()
            account_item['method'] =account.xpath('.//div/div/div/h4[4]/text()').extract_first()
            yield account_item