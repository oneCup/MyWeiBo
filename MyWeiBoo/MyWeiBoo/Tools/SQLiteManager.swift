//
//  SQLiteManager.swift
//  测试FMDB
//
//  Created by 李永方 on 15/10/26.
//  Copyright © 2015年 李永方. All rights reserved.
//

import Foundation

//注意:默认的数据库文件名,如果以db结尾,容易被发现
//SQLite公开的版本不支持加密,如果需要加口令,可以去github找一个扩展
private let dbName = "readme.db"
//创建一个数据库管理的类
class SQLiteManager {
    
    //创建单例
    static let sharedManager = SQLiteManager()
    
    //能够保证线程安全,需要有一个串行队列
    
    let queque: FMDatabaseQueue
    
    //在构造函数中,建立数据队列,保证创建的时候创建/打开数据库
    init() {
        let path = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! as NSString).stringByAppendingPathComponent(dbName)
        
        print(path)
        
        //创建数据库队列
        //如果数据库不存在,会新建数据库,否则会直接打开
        //后续的数据库操作,都通过quque打开
        queque = FMDatabaseQueue(path: path)
        
        createTable()
    }
    
    //MARK:创建表
    func createTable() {
        
        //获取sql路径
        let path = NSBundle.mainBundle().pathForResource("tables.sql", ofType: nil)
        
        //获取sql
        let sql = try! String(contentsOfFile: path!)
    
        
        //创建表
        queque.inTransaction { (db, rollback) in
            
            //执行多条sql回滚
            if db.executeStatements(sql) {
            
                print("创建数据表成功")

            }else {
            
                print("创建数据表失败")
            
            
            }
        }
    
    }
    
   
    

}