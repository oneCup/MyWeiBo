//
//  YFYFoAuthViewController.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/10.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit
import SVProgressHUD

class YFYFoAuthViewController: UIViewController,UIWebViewDelegate {
    
    //Mark:搭建界面
    private lazy var webView = UIWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view = webView
        webView.delegate = self
        title = "新浪微博"
        //加载授权页面
        webView.loadRequest(NSURLRequest(URL: YFNETWorkTools.sharedTools.oauthUrl()))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: "close")
        }
    
/************************代理方法实现******************************/
    
// MARK:UIWebViewDelegatewebView代理方法实现
    func webViewDidStartLoad(webView: UIWebView) {
        //显示网络加载转轮
        SVProgressHUD.show()
        print("开始")
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        print("结束")
        SVProgressHUD.dismiss()
    }

    
    /* 1 如果请求的URL包含回调地址,否则继续加载
       2 如果请求参数中包含code,可以从url中获得请求码
        request.URL?.query可获得值
    */
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print(request)
        //包含完整的字符串  absoluteString(完成的字符串)
        let urlString = request.URL!.absoluteString
        //判断是否包含回调地址,不包含,返回正确
        if !urlString.hasPrefix(YFNETWorkTools.sharedTools.redirect_uri) {
            return true
            }
        print("qurey---->\(request.URL?.query)")
        if let query = request.URL?.query where query.hasPrefix("code=") {
            
            //获取授权码
            //query.substringFromIndex("code=".endIndex)截取字符串从"code="最后一个字符串开始
           let code =  query.substringFromIndex("code=".endIndex)
            print("获取授权\(code)")
            loadAccessToken(code)
            //登录成功,进入欢迎界面
            NSNotificationCenter.defaultCenter().postNotificationName(YFRootViewControollerSwithNotifacation, object: false)
        }else {
            //取消授权后,回到主界面
            close()
        }
        return false
    }

/**********************************加载Token****************************/
//MARK:加载授权密码
//加载用户信息 - 调用方法,异步获取用户附加信息
//用的方法:加载网络获取token
    private func loadAccessToken(code: String){
        YFNETWorkTools.sharedTools.loadAccessToken(code) { (result, error) -> () in
        if error != nil || result == nil {
            self.netError()
            return
            }
        //字典中加载用户信息
        YFUserAcount(dict:result!).loadUserInfo({ (error) -> () in
           self.netError()
        })
        }
    }
    
//************网络错误处理*********************//
    private func netError() {
    
        SVProgressHUD.showInfoWithStatus("您的网络不给力")
        //网络不给力时,返回主界面(延时)
        let when = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC))
        dispatch_after(when, dispatch_get_main_queue()){
            self.close()
        }
        return
    }
    
//MARK:关闭界面
    func close() {
        SVProgressHUD.dismiss()
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
