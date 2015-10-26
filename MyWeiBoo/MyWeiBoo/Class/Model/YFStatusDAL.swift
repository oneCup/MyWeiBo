//
//  YFStatusDAL.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/26.
//  Copyright © 2015年 李永方. All rights reserved.
//

import Foundation

class YFStatusDAL {
    
    ///  数据库访问加载
    
    ///  从数据库&网络中加载数据
    
    class func loadstatus() {
        
        //1.检查本地是否有缓存数据
        
        //2.如果有缓存数据,直接返回缓存数据
        
        //3.如果没有缓存数据,从网络中加载数据
        
        //4.加载好好缓存数据后,保存到数据库中
        
        //5.完成回调
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
