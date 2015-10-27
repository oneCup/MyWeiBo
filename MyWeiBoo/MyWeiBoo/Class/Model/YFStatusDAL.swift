//
//  YFStatusDAL.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/26.
//  Copyright © 2015年 李永方. All rights reserved.
//

import Foundation
//设置数据库缓存时间的长度
private let dbCacheDateTime: NSTimeInterval = 60 // 1* 24 *3600  一般为1天,为方便测试
class YFStatusDAL {
    
    
    //MARK:清除数据缓存数据
    class func clearDateCache() {
        
        //  1.确定删除缓存日期
        let date = NSDate(timeIntervalSinceNow: -dbCacheDateTime)
        //转换日期格式
        let df = NSDateFormatter()
        df.locale = NSLocale(localeIdentifier:"en")
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = df.stringFromDate(date)
        print(dateString)
        //  2.执行清除缓存的代码
        let sql = "DELETE FROM T_Status WHERE createTime < '\(dateString)'"
        
        SQLiteManager.sharedManager.queque.inDatabase { (db) -> Void in
            
            db.executeUpdate(sql)
            print("删除成功")
        }
        
    }
    
    ///  数据库访问加载
    
    ///  从数据库&网络中加载数据
    
    class func loadstatus(since_id:Int, max_id: Int,finished:(arry: [[String: AnyObject]]?,error:NSError?)->()) {
        
        //1.检查本地是否有缓存数据
        loadCacheData(since_id, max_id: max_id) { (arry) -> () in
            if (arry?.count ?? 0) > 0 {
                
                 //2.如果有缓存数据,直接返回缓存数据
                finished(arry: arry,error: nil)
                return
            }
            
             //3.如果没有缓存数据,从网络中加载数据
            YFNETWorkTools.sharedTools.loadStatus(since_id, max_id: max_id, finished: { (result, error) -> () in
                
                /// 判断能否获得字典数组
                if let array = result?["statuses"] as? [[String: AnyObject]] {
                    
                     //4.加载好好缓存数据后,保存到数据库中
                    saveStatus(array)
                      //5.完成回调
                    finished(arry: array, error: nil)
                }else {
                    
                finished(arry: nil, error: error)
                }
                
            })
            
        }
     }
    
    //MARK:加载缓存数据
    
    
    class func loadCacheData(since_id:Int, max_id: Int,finished:(arry: [[String: AnyObject]]?)->()) {
        
        let userId = YFUserAcount.sharedAcount!.uid!
        
        var sql = "SELECT statusId, status, userId FROM T_Status \n" +
        "WHERE userId = \(userId) \n"
        
        //根据参数,调整查询条件
        if since_id > 0 { //下拉刷新
            sql += "AND statusId > \(since_id)\n"
        }else if max_id > 0 { //上拉刷新
        
            sql += "AND statusId < \(max_id)\n"
        
        }
        
        sql += "ORDER BY statusId DESC LIMIT 20;"
        
        print(sql)
        //执行sql
        SQLiteManager.sharedManager.queque.inDatabase { (db) -> Void in
            
            guard let rs = db.executeQuery(sql) else {
                
                //空数据的回调
                finished(arry: nil)
            
                return
            }
            //生成查询结果-返回什么样的结果 ->字典数组
            var arry = [[String: AnyObject]]()
            
            //遍历
            while rs.next() {
                let jsonString = rs.stringForColumn("status")
                print(jsonString)
                //反序列化
                let dict = try! NSJSONSerialization.JSONObjectWithData(jsonString.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions(rawValue: 0))
                //将字典插入数组
                arry.append(dict as! [String: AnyObject])
            }
            
            //通过回调返回数组
            
            finished(arry: arry)
        }
        
        
    }
    
    //MARK:保存数据到数据库
    ///保存数据到数据库
    class func saveStatus(array: [[String: AnyObject]]) {
        
        //判断用户是否登录
        assert(YFUserAcount.userLogin, "必须登录")
        
        let userId = YFUserAcount.sharedAcount!.uid!
        
        //1.准备sql
        let sql = "INSERT OR REPLACE INTO T_status (statusId, status, userId) VALUES (?,?,?);"
        //2.执行语句
        SQLiteManager.sharedManager.queque.inTransaction { (db, rollback) -> Void in
            
            //1.遍历数组
            for dict in array {
            
                //1.微博账号
                let statusID = dict["id"] as! Int
                let json = try! NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions(rawValue: 0))
//                print(json)
                let jsonString = NSString(data: json, encoding: NSUTF8StringEncoding)!
                
                //3>插入数据到数据库
                
                if  !db.executeUpdate(sql, statusID,jsonString,userId) {
                    //执行回滚,返回到上一层的正确的程序中
                    rollback.memory = true
                    break
                }
            
            }
            //输出结果
            print("------->保存了\(array.count)条数据")
        }
        
        
    }
    
}
