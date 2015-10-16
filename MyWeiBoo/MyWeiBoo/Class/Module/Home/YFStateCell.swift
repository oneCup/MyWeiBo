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
    
    ///  图片宽度约束
    var pictureWidthCons :NSLayoutConstraint?
    
    ///  图片高度约束
    var pictureHeightCons : NSLayoutConstraint?
    
    /// 约束piv与ContentView防止当picture不存在时,contentView与底部存在两倍的间距
    var pictureHeightTopCons : NSLayoutConstraint?


    
    //设置微博数据
    var status : YFStatues?  {
    
        didSet{
            pictureView.status = status
            TopView.status = status
            ContentLable.text = status?.text ?? ""
            pictureWidthCons?.constant = pictureView.bounds.size.width
            pictureHeightCons?.constant = pictureView.bounds.size.height
            pictureHeightTopCons?.constant == 0 ? 0 :stateCellMargin
            
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
    func setUpUI() {
        
        contentView.addSubview(TopView)
        contentView.addSubview(ContentLable)
        contentView.addSubview(bottomView)
        contentView.addSubview(pictureView)
        
        //1>顶部视图
        TopView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: contentView,
            size:CGSize(width: UIScreen.mainScreen().bounds.width, height: 53))
        //2>标签视图
        ContentLable.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: TopView, size: nil, offset: CGPoint(x:stateCellMargin , y: stateCellMargin))
            //宽度
        contentView.addConstraint(NSLayoutConstraint(item:ContentLable, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: -2 * stateCellMargin))
//        //3.多图视图
//        let cons = pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: ContentLable, size:CGSize(width: 290, height: 290),offset: CGPoint(x: 0, y: stateCellMargin))
//        //记录约束属性
//        pictureWidthCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Width)
//        pictureHeightCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
//        pictureHeightTopCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Top)
        
        
        //3.底部视图
        bottomView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: pictureView, size: CGSize(width: UIScreen.mainScreen().bounds.width, height:44), offset: CGPoint(x: -stateCellMargin, y: stateCellMargin))
       
    
    }
    
    //Mark:懒加载控件视图
   //顶部视图
     var TopView: YFTopView = YFTopView()
    //设置文本视图
     var ContentLable: UILabel = {
    //设置内容标签
     let lable = UILabel(color: UIColor.darkGrayColor(), fontSize: 12)
        lable.numberOfLines = 0
//        lable.sizeToFit()
        //TODO:为什么要使用这句话
        lable.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 2 * 8
        
        return lable
    }()

/// 图片行高
      func rowHeight(status:YFStatues)-> CGFloat {
        //设置属性
        self.status = status
        //强制更新布局
        //使用自动布局,不需要修该frame,修改的工作交给自动布局来完成
        layoutIfNeeded()
        //返回底部视图
        return CGRectGetMaxY(bottomView.frame)
    }
   
    
    //底部视图
    lazy var bottomView:YFButtomview = YFButtomview()
    
    //多图视图
    lazy var pictureView:YFPictureView = YFPictureView()
    
   }
