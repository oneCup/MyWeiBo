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
    func inputEmoticon() {
    
    
        print("选择表情")
    
    
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
        prepareText()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("b\(view)")
        
    }
    
    func prepareText() {
    
        //1.加载
        view.addSubview(textview)
        //2.设置布局
        textview.backgroundColor = UIColor.whiteColor()
        textview.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        textview.ff_AlignInner(type: ff_AlignType.TopLeft, referView: view, size: nil)
        textview.ff_AlignVertical(type: ff_AlignType.TopRight, referView: toolbar, size: nil)
        
        textview.addSubview(placeholderLabel)
        
        placeholderLabel.ff_AlignInner(type: ff_AlignType.TopLeft, referView: textview, size: nil, offset: CGPointMake(6, 8))

        
        
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
        
         view.addSubview(toolbar)
        //2.设置颜色
        toolbar.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        //3.设置布局
        toolbar.ff_AlignInner(type: ff_AlignType.BottomLeft, referView: view, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 44))
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
            items.append(UIBarButtonItem(imageName: dict["imageName"]!, target: self, action: dict["action"]))
            
            //追加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
       
       toolbar.items = items
    }
    
    //MARK:懒加载
    //文本视图
    private lazy var textview: UITextView = {
    
        let textvie = UITextView()
//        textvie.text = "分享新鲜事"
        textvie.backgroundColor = UIColor.lightGrayColor()
        textvie.font = UIFont.systemFontOfSize(18)
        //设置可拖动
        textvie.alwaysBounceVertical = true
        //拖拽关闭键盘
        textvie.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        return  textvie
        
    }()
    
    //工具栏
    private lazy var toolbar: UIToolbar = UIToolbar()
///  设置占位标签
    
    private  lazy var placeholderLabel : UILabel = {
    
        let label =  UILabel(color: UIColor.lightGrayColor(), fontSize: 18)
        label.text = "分享新鲜事"
        
        label.sizeToFit()
        
        return label
        
        
    }()
 }
