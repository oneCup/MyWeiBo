//
//  YFStatues.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/14.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit

class YFStatues: NSObject {
    
    /// 微博创建时间
    var created_at: String?
    /// 微博ID
    var id: Int = 0
    /// 微博信息内容
    var text: String?
    /// 微博来源
    var source: String?
    /// 显示微博所需的行高
    var rowHeight: CGFloat?
    /// 配图数组(字典类型)
    var pic_urls: [[String: AnyObject]]? {
    
        didSet{
            //判断字典中是否有值
            if pic_urls?.count == 0 {
        
                return
            }
            //遍历生成字典
            PictursURL = [NSURL]()
            
            for dict in pic_urls! {
            
                if let url = dict["thumbnail_pic"] as? String {
                    
                    PictursURL?.append(NSURL(string: url)!)
                }

            }
        }
    
    }
    ///  配图的
    var PictursURL: [NSURL]?
    /// 用户
    var user: YFUser?
     //MARK:字典转模型
      class func loadStatus(finished:(datalist:[YFStatues]?,error: NSError?) ->()) {
        
        YFNETWorkTools.sharedTools.loadStatus { (result, error) -> () in
            
            if(error != nil) {
            
//            finished(datalist: nil, error: error)
                
                return
            
            }
            
            //判断是否可以获得字典数
            
            /// 判断能否获得字典数组
            if let array = result?["statuses"] as? [[String: AnyObject]] {
                // 遍历数组，字典转模型
                var list = [YFStatues]()
                
                for dict in array {
                    list.append(YFStatues(dict: dict))
                }
                
                //转换为字典后,完成回调
                
                finished(datalist: list, error: nil)
            }else {
            
            finished(datalist: nil, error:nil)
            
            
            }
            
        }
        

    }
    //kvc
    init(dict: [String: AnyObject]) {
        super.init()
    
        setValuesForKeysWithDictionary(dict)
    }
    //拦截设置对象属性
    override func setValue(value: AnyObject?, forKey key: String) {
        if key == "user" {
       
            if let dict = value as? [String: AnyObject]{
            
                user = YFUser(dict: dict)
            }
            return
        }
        //TODO:为什么要写在后面
        super.setValue(value, forKey: key)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    
    override var description: String {
        let keys = ["created_at", "id", "text", "source", "pic_urls"]
        
        return "\(dictionaryWithValuesForKeys(keys))"
    }

}
