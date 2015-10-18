//
//  YFMainController.swift
//  MyWiBo
//
//  Created by 李永方 on 15/10/7.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit

class YFMainController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //加入5个视图控制器
        addChildViewControllers()
        print(tabBar.subviews)
        

        // Do any additional setup after loading the view.
    }
    
    //添加UIButton
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print(tabBar.subviews)
        setUpComposedButton()
    }
    //添加所有控制器
    private func addChildViewControllers() {
        
        // 只是添加控制器,并没有创建tabar的button
        
        addChildViewController(YFHomeController(),title: "首页", image:"tabbar_home")
        
        addChildViewController(YFMessageController(), title: "消息", image: "tabbar_home")
        //创建一个uiview的子控制器
        addChildViewController(UIViewController())
        
        addChildViewController(YFDiscoverController(), title: "发现", image: "tabbar_discover")
        
        addChildViewController(YFProfileController(), title: "我", image: "tabbar_profile")
        
    }
    
    //添加子控制器
    private func addChildViewController(vc: UIViewController, title:String, image:String) {
        
        
        //创建vc
        vc.title = title;
        //设置tincolor
//        tabBar.tintColor = UIColor.orangeColor()
        
        vc.tabBarItem.image = UIImage(named: image)
        
        //创建一个视图控制器为跟控制器
        
        let nav = UINavigationController(rootViewController: vc)
        
        addChildViewController(nav)
        
    }
    
    //创建一个自定义视图(懒加载控件)
    
    lazy private var composeButton : UIButton = {
    
    //自定义类型按钮
        
        let button = UIButton()
        
        button.setImage(UIImage(named: "tabbar_compose_icon_add"), forState:  UIControlState.Normal)
        button.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState:UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        
        //加入到tabar(在闭包内部需要引用self)
        self.tabBar.addSubview(button)
        //监听事件
        button.addTarget(self, action: "clickComposeButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    
    }()
    
    //button的单击事件
   
    func clickComposeButton() {
    
       // 1.创建一个撰写视图控制器
        let vc = YFUserAcount.userLogin ? YFComposedViewController() : YFYFoAuthViewController()
        let nav = UINavigationController(rootViewController: vc)
       
        
        //弹出
        presentViewController(nav, animated: true, completion: nil)
    
    }
    //创建button的frame
    private func setUpComposedButton() {
    
        let w = tabBar.bounds.width / CGFloat((viewControllers?.count)!)
        let rect = CGRect(x: 0, y: 0, width: w, height: tabBar.bounds.height)
        composeButton.frame = CGRectOffset(rect, 2 * w, 0)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
}
