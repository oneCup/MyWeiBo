//
//  NSDateExtension.swift
//  日期时间设置
//
//  Created by 李永方 on 15/10/24.
//  Copyright © 2015年 李永方. All rights reserved.
//

import Foundation

extension NSDate {

    //新浪微博日期字符串装换成日期

    class func sinaDate(string : String) ->NSDate? {
        
        
        //转换成日期
        let df = NSDateFormatter()
        //提示:地区一定要指定,否则真机运行会有问题,同意用en
        df.locale = NSLocale(localeIdentifier: "en")
        
        //日期格式字符串
        df.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"

        
        //转换成日期字符串
        return df.dateFromString(string)
    }
    /**
    刚刚(一分钟内)
    X分钟前(一小时内)
    X小时前(当天)
    昨天 HH:mm(昨天)
    MM-dd HH:mm(一年内)
    yyyy-MM-dd HH:mm(更早期)
    */

        var dateDescription: String {
        
        //日历类,提供了非常丰富的日期转换函数
        //1.取出当前日期
        let cal = NSCalendar.currentCalendar()
        
        //2.判断是否是今天
        if cal.isDateInToday(self) {
            
            //使用日期和当前的系统时间进行比较,判断相差的秒数
            let delta = Int(NSDate().timeIntervalSinceDate(self))
            if delta < 60 {
                return "刚刚"
            }
            
            if delta < 3600 {
            
                return "\(delta / 60) 分钟前"
            }
            
            return "\(delta / 3600) 小时前"

         }
        ///  日期格式字符串
            var frmtString = "HH:mm"
         ///3.判断是否是昨天
        if cal.isDateInYesterday(self) {
       
           frmtString = "昨天" + frmtString
        }else {
            
            frmtString = "MM-dd" + "-" + frmtString
            //4.判断年度
            let coms = cal.components(NSCalendarUnit.Year, fromDate: self, toDate:NSDate(), options: NSCalendarOptions(rawValue: 0))
            //判断时间对比
            if coms.year > 0 {
                
                frmtString = "yyyy-" + frmtString

            }
        }
        let df = NSDateFormatter()
            
        df.locale = NSLocale(localeIdentifier: "en")
        df.dateFormat = frmtString
        
        return df.stringFromDate(self)
        

    }
}


