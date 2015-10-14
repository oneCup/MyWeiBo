//
//  UILabel+Extension.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/14.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit

extension UILabel {

    convenience init(color:UIColor,fontSize:CGFloat) {
        
        self.init()
        textColor = color
        font = UIFont.systemFontOfSize(fontSize)
        
    }


}
