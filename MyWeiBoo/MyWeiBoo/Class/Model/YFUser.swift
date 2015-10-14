//
//  YFUser.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/14.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit

class YFUser: NSObject {
    /// 用户代号
    var id: Int = 0
    /// 友好显示名称
    var name: String?
    /// 用户头像地址（中图），50×50像素
    var profile_image_url: String? {
        didSet {
            imageURL = NSURL(string: profile_image_url!)
        }
    }
    //头像URL
    var imageURL:NSURL?
    
    //用户认证类型
    /// 用户的认证类型，-1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
    var verified_type: Int = -1
    /// 认证图标
    var vipImage: UIImage? {
        switch verified_type {
            
        case 0: return UIImage(named: "avatar_vip")
        case 2, 3, 5: return UIImage(named: "avatar_enterprise_vip")
        case 220: return UIImage(named: "avatar_grassroot")
        default: return nil
        }
    }
    
    ///  会员等级
    var mbrank: Int = -1
    ///  会员图像
    var memberImage: UIImage? {
        if mbrank > 0 && mbrank < 7 {
            return UIImage(named: "common_icon_membership_level\(mbrank)")
        } else {
            return nil
        }
    }
    
    //MARK:构造函数
    init(dict: [String: AnyObject]) {
    
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}



}
