//
//  YFStatusNormalCell.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/17.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit

class YFStatusNormalCell: YFStateCell {

    override func setUpUI() {
        
        super.setUpUI()
        
        let cons = pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: ContentLable, size:CGSize(width: 290, height: 290),offset: CGPoint(x: 0, y: stateCellMargin))
        //记录约束属性
        pictureWidthCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureHeightCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
        pictureHeightTopCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Top)

    }
  
    
}
