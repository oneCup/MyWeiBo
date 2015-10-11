//
//  YFBaseTableViewController.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/8.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit

class YFBaseTableViewController: UITableViewController, VisitorLoginDelegate {
    
    //设置用户登录标记
    var userLogon = false
    
    //设置视图属性
    var VisitorView:YFVisitorView?
    
// MARK:加载视图(判断用户登录)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 根据用户是否登录判断是否替换根式图
        userLogon ? super.loadView() : setupVisitorView()
        

            }
    
// MARK: 设置访客视图
    private func setupVisitorView(){
        
        VisitorView = YFVisitorView()
        view = VisitorView
        
        //设置代理
        VisitorView?.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: "visitorWillLogin")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "visitorWillRegester")
        
    }
    
//  MARK:--代理实现VisitorLoginDelegate
    
    func visitorWillLogin() {
        
        //加载授权登陆界面(此时,如果第一次登陆会直接到登陆界面)(登陆界面是mosal出来的,一定要dismit )
        let nav = UINavigationController(rootViewController: YFYFoAuthViewController())
       presentViewController(nav, animated: true, completion: nil)
        
        
        //modal出一个登陆界面
//
//        presentationController(nav,animated: true,completion:nil)
        
        print(__FUNCTION__)
        
    }
    
    func visitorWillRegester() {
        print(__FUNCTION__)
    }
  
}
