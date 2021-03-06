//
//  YFStateCell.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/14.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit

protocol stateCellDidSelectedLinkDelegate: NSObjectProtocol {

    func stateCellDidSelectedLink(text:String)
}


let stateCellMargin : CGFloat = 8

///  定义一个表示符枚举
enum StatuCellIndentifier: String {
    
    case NormalCell = "NormalCell"
    case ForwardCell = "ForwardCell"
    
    //静态函数
    static func cellID(status:YFStatues) ->String {
        
        return status.retweeted_status == nil ? StatuCellIndentifier.NormalCell.rawValue : StatuCellIndentifier.ForwardCell.rawValue
    }
}


class YFStateCell: UITableViewCell {
    
    /// 超文本连接代理
    weak var delegate: stateCellDidSelectedLinkDelegate?
    
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
        
        
        //3.底部视图
        bottomView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: pictureView, size: CGSize(width: UIScreen.mainScreen().bounds.width, height:44), offset: CGPoint(x: -stateCellMargin, y: stateCellMargin))
       
    
    }
    
    //Mark:懒加载控件视图
   //顶部视图
     lazy var TopView: YFTopView = YFTopView()
    //设置文本视图
    lazy var ContentLable: FFLabel = {
        //设置内容标签
        let label = FFLabel(color: UIColor.darkGrayColor(), fontSize: 12)
        
        label.labelDelegate = self
        
        label.numberOfLines = 0
        
        // lable.sizeToFit()
        //TODO:为什么要使用这句话
        
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 2 * 8
        
        
        return label
    }()

/// 图片行高
      func rowHeight(status:YFStatues)-> CGFloat {
        //设置属性
        self.status = status
        print(status)
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


//MARK:labelDelegate 超文本代理
extension YFStateCell: FFLabelDelegate {

    func labelDidSelectedLinkText(label: FFLabel, text: String) {
        
        print(text)
        
        //判断是否是http协议
        if text.hasPrefix("http://"){
        
        self.delegate?.stateCellDidSelectedLink(text)
        }
    }
}