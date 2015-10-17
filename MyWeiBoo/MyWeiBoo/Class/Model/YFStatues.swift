//
//  YFStatues.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/14.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit
import SDWebImage

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
            stortedPictureURL = [NSURL]()
            
            for dict in pic_urls! {
            
                if let url = dict["thumbnail_pic"] as? String {
                    
                    stortedPictureURL?.append(NSURL(string: url)!)
                }

            }
        }
    
    }
    //设置转发微博的属性值
    var retweeted_status:YFStatues?
    //设置一个保存配图的URL数组
    var stortedPictureURL: [NSURL]?

    ///  配图的
    var PictursURL: [NSURL]? {
        
    retweeted_status == nil ? stortedPictureURL : retweeted_status?.stortedPictureURL
        
        return stortedPictureURL
    
    }
    /// 用户
    var user: YFUser?
     //MARK:字典转模型
      class func loadStatus(since_id:Int,max_id:Int,finished:(datalist:[YFStatues]?,error: NSError?) ->()) {
        
        YFNETWorkTools.sharedTools.loadStatus(since_id,max_id: max_id) { (result, error) -> () in
            if(error != nil) {
                finished(datalist: nil, error: error)
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
                cachWebImage(list, finished: finished)
                
                finished(datalist: list, error: nil)
            }else {
            
                finished(datalist: nil, error:nil)
            }
            
        }
    }
    
    
    ///  缓存网络图片,缓存结束后,才刷新图片
    
     class func cachWebImage(list:[YFStatues],finished:(datalist:[YFStatues]?,error: NSError?) ->()) {
    
        //创建调度组
        let group = dispatch_group_create()
        // 缓存图片
        var dataLength = 0
        
        //循环遍历数组
        for status in list {
        //判断是否有图片
            guard let urls = status.PictursURL else {
                continue
            }
            
        //便利urlImage数组
         
            for imageurl in urls {
                //入组
                dispatch_group_enter(group)
                SDWebImageManager.sharedManager().downloadImageWithURL(imageurl, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (image,_ , _ , _ , _ ) -> Void in
                    
                        //将图像转换成二进制数据
                        let data = UIImagePNGRepresentation(image)!
                        dataLength += data.length
                        dispatch_group_leave(group)
                        })
                    }
        }
        //通知组:监听所有缓存操作
        dispatch_group_notify(group, dispatch_get_main_queue(), { () -> Void in
            print("缓存大小\(dataLength)k")
            //离开组
        //完成回调
        finished(datalist: list, error: nil)
            
        })

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
        
        if key == "retweeted_status" {
        
            if let dict = value as? [String: AnyObject] {
            
                retweeted_status = YFStatues(dict: dict)
            }
            return
        
        }
        //TODO:为什么要写在后面
        super.setValue(value, forKey: key)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    
    override var description: String {
        let keys = ["created_at", "id", "text", "source", "pic_urls","retweeted_status"]
        
        return "\(dictionaryWithValuesForKeys(keys))"
    }

}
