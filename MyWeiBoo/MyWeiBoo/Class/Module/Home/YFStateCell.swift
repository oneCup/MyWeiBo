//
//  YFStateCell.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/14.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit

let stateCellMargin : CGFloat = 8

class YFStateCell: UITableViewCell {
    
    //设置微博数据
    var status : YFStatues?  {
    
        didSet{

            TopView.status = status
            ContentLable.text = status?.text ?? ""
                  }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
            setUpUI()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

       override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //设置UI界面
    private func setUpUI() {
        
        contentView.addSubview(TopView)
        contentView.addSubview(ContentLable)
        contentView.addSubview(bottomView)
        
                //1>顶部视图
        TopView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: contentView,
            size:CGSize(width: UIScreen.mainScreen().bounds.width, height: 53))
        //2>标签视图
        ContentLable.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: TopView, size: nil, offset: CGPoint(x:8 , y: 8))
            //宽度
        contentView.addConstraint(NSLayoutConstraint(item:ContentLable, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: -16))
        
        //3.底部视图
        bottomView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: ContentLable, size: CGSize(width: UIScreen.mainScreen().bounds.width, height:44), offset: CGPoint(x: -8, y: 8))
       contentView.addConstraint(NSLayoutConstraint(item: bottomView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
    
    }
    
    //Mark:懒加载控件视图
   //顶部视图
    private lazy var TopView: YFTopView = YFTopView()
    //设置文本视图
    private lazy var ContentLable: UILabel = {
    //设置内容标签
        let lable = UILabel(color: UIColor.darkGrayColor(), fontSize: 12)
        lable.numberOfLines = 0
//        lable.sizeToFit()
        //TODO:为什么要使用这句话
//        lable.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 2 * 8
        
        return lable
        }()
    
    //底部视图
    private lazy var bottomView:YFButtomview = YFButtomview()
   }
