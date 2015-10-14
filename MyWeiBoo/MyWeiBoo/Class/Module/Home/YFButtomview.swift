//
//  YFButtomview.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/14.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit

class YFButtomview: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:设置控件
    func setUpUI() {
        
        //加载控件
        addSubview(forwardButton)
        addSubview(comentButton)
        addSubview(LikeButton)
        
        //设置布局(平铺)
        backgroundColor = UIColor.orangeColor()
        ff_HorizontalTile([forwardButton,comentButton,LikeButton], insets:UIEdgeInsetsZero)

    }

    //MARK:懒加载
    private lazy var forwardButton : UIButton  = UIButton(title: " 转发", imageName: "timeline_icon_retweet", fontsize: 12)
    private lazy var comentButton: UIButton = UIButton(title: " 评论", imageName: "timeline_icon_comment", fontsize: 12)
    private lazy var LikeButton: UIButton = UIButton(title: " 赞", imageName: "timeline_icon_unlike", fontsize: 12)


}