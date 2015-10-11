//
//  YFVisitorView.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/8.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit

// MARK:登录协议
protocol VisitorLoginDelegate: NSObjectProtocol {

 /// 将要登录
    func visitorWillLogin()
 /// 将要注册
    func visitorWillRegester()

}

class YFVisitorView: UIView {

    //定义代理属性--一定要使用weak
    
    weak var delegate : VisitorLoginDelegate?
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //创建视图
        setUpUI()
        
    }
    
// MARK: 设置视图信息
    
    func setUpViewInfo(isHome:Bool, imageNamed:String, messageText:String) {
    
        iconView.image = UIImage(named: imageNamed)
        
        messageLable.text = messageText
        
        HomeIconView.hidden = !isHome
        
        //判断是否有动画,如果没有,没有就讲遮罩放在最底层,如果有就开始动画
        
        isHome ? StartAnimated() : sendSubviewToBack(maskIconView)
    
    }
    
// MARK: 设置动画
    
    func StartAnimated() {
    
        //设置核心动画
        
        let animated = CABasicAnimation(keyPath: "transform.rotation")
        
        animated.toValue = 2 * M_PI
        
        animated.repeatCount = MAXFLOAT
        
        animated.duration = 20.0
        
        //为了防止将切换界面时动画丢失,设置动画属性
        
        animated.removedOnCompletion = false
        
        iconView.layer.addAnimation(animated, forKey: nil)
        
    
    }

    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        // 禁止用 sb / xib 使用本类
        // fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        
        setUpUI()

    }
    
    //登录事件
    func clickLoginButton () {
    
        //代理执行代理方法
        delegate?.visitorWillLogin()
        print(__FUNCTION__)
    
    }
    
    //注册事件
    func clickResignButton() {
        //代理执行代理方法
        delegate?.visitorWillRegester()
        print(__FUNCTION__)
    
    }
    
    //设置界面元素
    private func setUpUI() {
    
        //将图标加载到视图
        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(HomeIconView)
        addSubview(messageLable)
        addSubview(regestorButton)
        addSubview(loginButton)
        
        //自动布局
        //1>图标
        iconView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))

        addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: -40))
        //2>小房子
        HomeIconView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: HomeIconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: HomeIconView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        //3>描述文字
        messageLable.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: messageLable, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: messageLable, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: messageLable, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 224))
        //4>注册按钮
        regestorButton.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: regestorButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: messageLable, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: regestorButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: messageLable, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 16))
        
        addConstraint(NSLayoutConstraint(item: regestorButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 100))
        
        addConstraint(NSLayoutConstraint(item: regestorButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 35))
        
        //5>登录按钮
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: messageLable, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: messageLable, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 16))
        
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 100))
        
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 35))
        
        //6>遮罩视图
        maskIconView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[subview]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["subview":maskIconView]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[subview]-(-35)-[regButton]", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views:["subview": maskIconView, "regButton": regestorButton]))
        
        //设置背景图片
        backgroundColor = UIColor(white: 237.0 / 255.0, alpha: 1.0)

    }
    
    /// 图标
    private lazy var iconView: UIImageView = {
    
        let icon = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        return icon
        
    }()
    
    private lazy var maskIconView: UIImageView = {
        
        let icon = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        return icon
        
        }()
  
    /**
    首页小房子
    */
    private lazy var HomeIconView: UIImageView = {
    
    let icon = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    
    return icon
        
    }()
    
    /**
    描述文字
    */
    private lazy var messageLable: UILabel =  {
    
        let label = UILabel()
        label.text = "关注一些人，回这里看看有什么惊喜"
        label.font = UIFont.systemFontOfSize(14)
        label.textColor = UIColor.darkGrayColor()
        label.textAlignment = NSTextAlignment.Center
        label.numberOfLines = 0
        return label
        
        }()
    /**
    注册按钮
    */
    private lazy var regestorButton : UIButton = {
        
        let button = UIButton()
        
        button.setTitle("注册", forState: UIControlState.Normal)
        
        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        button.addTarget(self, action: "clickResignButton", forControlEvents: UIControlEvents.TouchUpInside)
        return button
        
        }()
    
    /**
    登录按钮
    */
    
    private lazy var loginButton : UIButton = {
    
        let button = UIButton()
        button.setTitle("登录", forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)

        //注册监听事件
        button.addTarget(self, action: "clickLoginButton", forControlEvents: UIControlEvents.TouchUpInside)
        return button
    
    }()
    
}


