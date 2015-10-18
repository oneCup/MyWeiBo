//
//  YFComposedViewController.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/18.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit

class YFComposedViewController: UIViewController {
    
    //监听方法
    func close() {
    
        dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    func sendStatus() {
        
        print("发布微博")
    
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
         print("c\(view)")
        view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)

        
    }
    
    override func loadView() {
        view = UIView()
        print("a\(view)")
        prepareNav()
        prepareToolbar()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("b\(view)")
        
    }
    

    func  prepareNav() {
    
        // 1.左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "close")
        
        //2.右边按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: "sendStatus")
        
        //3.标题栏
        let titleView = UIView(frame: CGRectMake(0, 0, 200 , 32))
        let titleLable = UILabel(color: UIColor.darkGrayColor(), fontSize: 14)
        titleLable.text = "发微博"
        titleLable.sizeToFit()
        titleView.addSubview(titleLable)
        titleLable.ff_AlignInner(type: ff_AlignType.TopCenter, referView: titleView, size: nil)
        
        //4.昵称
        let nameLabel = UILabel(color: UIColor.darkGrayColor(), fontSize: 14)
        
        nameLabel.text = YFUserAcount.sharedAcount?.name
        
        nameLabel.sizeToFit()
        
        titleView.addSubview(nameLabel)
        
        nameLabel.ff_AlignInner(type: ff_AlignType.BottomCenter, referView: titleView, size: nil)
        navigationItem.titleView = titleView
    
    }
    
    ///  准备toolbar
    
    func prepareToolbar() {
        
        //1.创建toolBar
        let toolBar = UIToolbar()
        //2.设置颜色
        toolBar.backgroundColor = UIColor.redColor()
        //3.设置布局
        view.addSubview(toolBar)
        
        toolBar.ff_AlignInner(type: ff_AlignType.BottomLeft, referView: view, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 44))
        // 定义一个数组
        let itemSettings = [["imageName": "compose_toolbar_picture"],
            ["imageName": "compose_mentionbutton_background"],
            ["imageName": "compose_trendbutton_background"],
            ["imageName": "compose_emoticonbutton_background", "action": "inputEmoticon"],
            ["imageName": "compose_addbutton_background"]]
        
        var items = [UIBarButtonItem]()
        
        for dict in itemSettings {
            
            //创建barButton从字典中获取
            // 创建 barButton 从字典中取值，如果 key 不存在，会得到 nil
            let button = UIButton()
            button.setImage(UIImage(named: dict["imageName"]!), forState: UIControlState.Normal)
            button.setImage(UIImage(named: dict["imageName"]! + "_highlighted"), forState: UIControlState.Highlighted)
            button.sizeToFit()
            
            //设置监听方法 判断actionKey是否存在
            
            if let actionName = dict["action"] {
            
                button.addTarget(self, action: Selector(actionName), forControlEvents: UIControlEvents.TouchUpInside)
            }
            
            let item = UIBarButtonItem(customView: button)

            items.append(item)
            //追加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
       
        toolBar.items = items
    }
    

    
}
