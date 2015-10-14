//
//  YFTopView.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/14.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit

class YFTopView: UIView {
    
///  status属性
    var status:YFStatues? {
        didSet{
        //设置控件值
            if let url = status?.user?.imageURL {
            iconView.sd_setImageWithURL(url)
            }
            nameLable.text = status?.user?.name
            timeLabel.text = " 刚刚"
            sourceLabel.text = " 来自微博"
            memIconView.image = status?.user?.memberImage
        }
    }
    
    //MARK:搭建界面
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
        
        setUpUI()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //布局控件
    func setUpUI() {
        
//        addSubview(UpTopView)
    //加载控件
        addSubview(iconView)
        addSubview(nameLable)
        addSubview(sourceLabel)
        addSubview(timeLabel)
        addSubview(memIconView)
        addSubview(VipIconView)
    //布局控件
//        UpTopView.ff_AlignVertical(type:ff_AlignType.TopLeft, referView:self, size: CGSize(width: UIScreen.mainScreen().bounds.size.width, height: 10))
        
        iconView.ff_AlignInner(type:ff_AlignType.BottomLeft, referView: self, size: CGSize(width: 35, height: 35),offset: CGPoint(x: 8, y: 0))
        nameLable.ff_AlignHorizontal(type: ff_AlignType.TopRight, referView: iconView, size: nil, offset: CGPoint(x: 8, y: 0))
        timeLabel.ff_AlignHorizontal(type: ff_AlignType.BottomRight, referView: iconView, size:nil, offset: CGPoint(x: 8, y: 0))
        sourceLabel.ff_AlignHorizontal(type: ff_AlignType.TopRight, referView: timeLabel, size: nil, offset: CGPoint(x: 8, y: 0))
        memIconView.ff_AlignHorizontal(type: ff_AlignType.TopRight, referView: iconView, size: nil, offset: CGPoint(x: 8, y: 0))
        VipIconView.ff_AlignInner(type: ff_AlignType.BottomRight, referView: iconView, size: nil,offset: CGPoint(x: 8, y: 8))
    
    }
    
//MARK:懒加载控件
///  1.图像图标
    private lazy var iconView: UIImageView = UIImageView()
    
///  2.姓名
    private lazy var nameLable: UILabel = UILabel(color: UIColor.darkGrayColor(), fontSize: 14)
    
///  3.来源标签
    private lazy var sourceLabel: UILabel = UILabel(color: UIColor.darkGrayColor(), fontSize: 12)
    
///  4.时间标签
    private lazy var timeLabel: UILabel = UILabel(color: UIColor.darkGrayColor(), fontSize: 12)
    
///  5.会员图标
    private lazy var  memIconView: UIImageView = UIImageView()
    
///  6.Vip图标
    private lazy var  VipIconView: UIImageView = UIImageView()
    
    //顶部拉条
    private lazy var UpTopView :UIView = {
        
        let View = UIView()
        View.backgroundColor = UIColor.darkGrayColor()
        
        return View
        }()
    }
