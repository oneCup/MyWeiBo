//
//  YFForwardCell.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/16.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit

class YFForwardCell: YFStateCell {

  override var status: YFStatues? {
        didSet {
            
            
        //TODO:返回的name,Text为空
        let name = status?.retweeted_status?.user?.name ?? ""
        let text = status?.retweeted_status?.text ?? ""

        forwardLabel.text = "@" + name + ":" + text
        }
    
    }
    
  override  func setUpUI() {
    
    super.setUpUI()
        //1.添加控件
        contentView.insertSubview(backButton, belowSubview: pictureView)
        contentView.insertSubview(forwardLabel, aboveSubview: backButton)
        //2.排版时测试
    
    
        //3.设置布局
            //3.1距离文本标签右左
    
        backButton.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: ContentLable, size: nil, offset: CGPoint(x: -stateCellMargin, y: stateCellMargin))
    
            //3.2距离底部视图右上
        backButton.ff_AlignVertical(type: ff_AlignType.TopRight, referView: bottomView, size: nil)
    
            //3.3转发微博标签
        forwardLabel.ff_AlignInner(type: ff_AlignType.TopLeft, referView: backButton, size: nil, offset: CGPoint(x:0, y: stateCellMargin))
    
            //3.4多图视图
        let cons = pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: forwardLabel, size:CGSize(width: 290, height: 290),offset: CGPoint(x: stateCellMargin, y: stateCellMargin))
        //记录约束属性
    //记录约束属性
        pictureWidthCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureHeightCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
        pictureHeightTopCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Top)
    
    }
   
    //MARK:懒加载文字
    private lazy var forwardLabel: FFLabel = {
    
        let label = FFLabel(color: UIColor.darkGrayColor(), fontSize: 14)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width
        label.labelDelegate = self
        return label

    }()
    
    //1>背景按钮
    
    private lazy var backButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        return btn
    }()
    
    //2> 转发文本
    
    
}
