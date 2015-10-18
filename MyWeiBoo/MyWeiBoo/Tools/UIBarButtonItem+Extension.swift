//
//  UIBarButtonItem+Extension.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/18.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit


extension UIBarButtonItem {
    //分类只能提供构造函数
    
    convenience init(imageName: String, target: AnyObject?, action: String?) {
        
        let button = UIButton()
        button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        button.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        button.sizeToFit()
        
        // 设置监听方法，判断 action key 是否存在,不存在为nil
        if let actionName = action {
            button.addTarget(target, action: Selector(actionName), forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        self.init(customView:button)
    }


}
