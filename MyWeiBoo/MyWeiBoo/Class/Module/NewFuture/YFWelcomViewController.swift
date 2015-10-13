//
//  YFWelcomViewController.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/11.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit
import SDWebImage

class YFWelcomViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prarareUI()
        //加载用户头像
        if let urlString = YFUserAcount.sharedAcount?.avatar_large {
            iconView.sd_setImageWithURL(NSURL(string: urlString)!)
            print("2---->\(urlString)")
        }
        
        //加载用户名称
        if let name = YFUserAcount.sharedAcount?.name {
            nameLable.text = name
            nameLable.sizeToFit()
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        startAnimated()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    //MARK:设置动画
    //拿到回弹的效果
    var constanceH: NSLayoutConstraint?
    
    private func startAnimated() {
        //更新约束
        constanceH?.constant = UIScreen.mainScreen().bounds.width + constanceH!.constant
        
        UIView.animateWithDuration(1.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5.0, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            
            // 强制更新约束
            self.view.layoutIfNeeded()
            
            }){ (_) -> Void in
                
            //发送通知
            NSNotificationCenter.defaultCenter().postNotificationName(YFRootViewControollerSwithNotifacation, object: true)
        }
    }
    
    ///MARK:准备界面
    private func prarareUI() {
    
        view.addSubview(backImageView)
        view.addSubview(iconView)
        iconView.addSubview(nameLable)
        view.addSubview(lable)
        
        //1 设置布局
        backImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[subviews]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["subviews":backImageView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[subviews]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views:["subviews": backImageView]))
        
        //2 设置iconView
        iconView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute:NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 90))
        
        view.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute:NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 90))
        
        view.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute:NSLayoutAttribute.Top, multiplier: 1.0, constant: 160))
        constanceH = view.constraints.last
        
        //设置昵称标签
        nameLable.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: nameLable, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: nameLable, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))

        //3.设置文字标签
        
        lable.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: lable, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: lable, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 16))
    }

    //MARK:-懒加载图片
    ///背景图片
    private lazy var backImageView: UIImageView = UIImageView(image: UIImage(named: "ad_background"))
    ///  用户头像
    private lazy var iconView: UIImageView = {
        
        //图像占位符
        let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 45
       
        return iv
    }()
    
    ///  消息文字
    private lazy var lable : UILabel = {
        let lable = UILabel()
        lable.text = "欢迎归来"
        lable.sizeToFit()
        return lable
    }()
   
    // 昵称lable
    private lazy var nameLable: UILabel = {
    
        let nameLable = UILabel()
        
        nameLable.font = UIFont.systemFontOfSize(14)
        nameLable.textAlignment = NSTextAlignment.Center
        nameLable.numberOfLines = 2
        
        return nameLable
    }()
}
