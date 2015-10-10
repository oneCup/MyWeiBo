//
//  YFUserAcount.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/11.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit

class YFUserAcount: NSObject{
    
    ///  access_token 用于调用access_token，接口获取授权后的access token。
    var access_token: String?
    ///  expires_in access_token的生命周期，单位是秒数\
    var expires_in: NSTimeInterval = 0
    ///  uid (string)当前授权用户的UID。可获取用户的图像
    var uid: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
    
        setValuesForKeysWithDictionary(dict)
    
    
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    //描述信息的打印
    override var description: String {
        
//        let properities = ["access_token","expires_in:","uid"]
         let properities = ["access_token","expires_in","uid"]
        
        
        //模型转字典
        
        return ("\(dictionaryWithValuesForKeys(properities))")
        
         }
    

}
