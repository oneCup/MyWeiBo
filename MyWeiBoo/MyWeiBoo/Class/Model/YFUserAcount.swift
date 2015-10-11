//
//  YFUserAcount.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/11.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit

class YFUserAcount: NSObject,NSCoding{
    
    ///  access_token 用于调用access_token，接口获取授权后的access token。
    var access_token: String?
    ///  expires_in access_token的生命周期，单位是秒数\
    var expires_in: NSTimeInterval = 0 {
        
        didSet{
        expires_Date = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    
    ///  uid (string)当前授权用户的UID。可获取用户的图像
    var uid: String?
    //过期日期
    var expires_Date: NSDate?
    /// 用户头像地址（大图），180×180像素
    var avatar_large: String?
    ///  name 友好显示名称
    var name:String?
       
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
        YFUserAcount.userAccout = self
        
       }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
    
    ///  调用归档解档的方法
    ///保存归档的文件路径
    //TODO:last?为什么用!

    static private let accoutPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!.stringByAppendingString("/account.plist")
    
    ///  保存用户的账号
    func saveAccountInfo() {
        NSKeyedArchiver.archiveRootObject(self, toFile: YFUserAcount.accoutPath)
        print(YFUserAcount.accoutPath)
    }
    private static var userAccout:YFUserAcount?
    
    ///  静态用户的账号属性
    ///
    ///  //判断用户账号是否存在,不存在,解档,存在判断日期是否过期,过期,则将日期设置为nil,不为空则直接返回

    class func LoadAccout ()-> YFUserAcount? {
        
       //判断用户账号是否存在
        if userAccout == nil {
        //1 解档 - 如果没有保存过,解档结果可能仍然为nil
            userAccout = NSKeyedUnarchiver.unarchiveObjectWithFile(accoutPath) as? YFUserAcount
        }
        
        if let date = userAccout?.expires_Date where date.compare(NSDate()) == NSComparisonResult.OrderedAscending {
            //如果已经过期,需要清空账号记录
            userAccout = nil
        }
        
        return userAccout
    }
    //MARK:加载用户信息
    //加载用户信息 - 调用方法,异步获取用户附加信息,保存当前用户
    
    func loadUserInfo(finished:(error:NSError?)->()) {
    
        YFNETWorkTools.sharedTools.loadUserInfo(uid!) { (result, error) -> () in
            
            if error != nil {
            //提示:error一定要传递
                finished(error: error)
                return
            }
            
            print(result)
            //设置用户信息
            self.name = result!["name"] as? String
            
            self.avatar_large = result!["avatar_large"] as? String
            //保存用户信息
            self.saveAccountInfo()
            }
    
    }
    
    //MARK:归档解档 NScoding
    /// `归`档 -> 保存，将自定义对象转换成二进制数据保存到磁盘
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeDouble(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_Date, forKey: "expires_Date")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
        
    }
    
    /// `解`档 -> 恢复 将二进制数据从磁盘恢复成自定义对象
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeDoubleForKey("expires_in")
        expires_Date = aDecoder.decodeObjectForKey("expires_Date") as? NSDate
        uid = aDecoder.decodeObjectForKey("uid") as? String
        name = aDecoder.decodeObjectForKey("name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
    
    }
    
    //描述信息的打印
    override var description: String {
         let properities = ["access_token","expires_in","uid","expires_Date","name","avatar_large"]
        //模型转字典
        return ("\(dictionaryWithValuesForKeys(properities))")
        
         }
    

}
