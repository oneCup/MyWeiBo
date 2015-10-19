//
//  UIButton+Extension.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/14.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit

extension UIButton{
    
    convenience init(title: String, imageName: String, fontsize: CGFloat,textColor: UIColor = UIColor.lightGrayColor()) {
        
        self.init()
        
        setTitle(title, forState: UIControlState.Normal)
        
        setImage(UIImage(named: imageName),forState:UIControlState.Normal)
        
        setTitleColor(textColor, forState: UIControlState.Normal)
        titleLabel?.font = UIFont.systemFontOfSize(fontsize)
        
        
    }
    
   

    convenience init(title: String, backColor: UIColor, fontsize: CGFloat,textColor: UIColor = UIColor.whiteColor()) {
        
        self.init()
        
        setTitle(title, forState: UIControlState.Normal)
        
        setTitleColor(textColor, forState: UIControlState.Normal)
        titleLabel?.font = UIFont.systemFontOfSize(fontsize)
        backgroundColor = backColor
        
    }
    


}
