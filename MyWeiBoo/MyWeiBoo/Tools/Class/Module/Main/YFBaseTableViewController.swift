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
    var VisitorView = YFVisitorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 根据用户是否登录判断是否替换根式图
        userLogon ? super.loadView() : setupVisitorView()
        

            }
///  设置访客视图
    private func setupVisitorView(){
        
        view = VisitorView
        //设置代理
        VisitorView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: "visitorWillLogin")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "visitorWillRegester")
        
    }

    func visitorWillLogin() {
        
        print(__FUNCTION__)
        
    }
    
    func visitorWillRegester() {
        print(__FUNCTION__)
    }
  
}
