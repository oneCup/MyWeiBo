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
    
    //关闭界面
    func close() {
        SVProgressHUD.dismiss()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
// MARK:UIWebViewDelegate
    func webViewDidStartLoad(webView: UIWebView) {
        //显示网络加载转轮
        SVProgressHUD.show()
        print("开始")
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
        
        //如果包含,判断参数
        print("判断参数")
        
        print(request.URL?.query)
        
        if let query = request.URL?.query where query.hasPrefix("code=") {
            
            print("获取授权")
            //获取授权码
            //query.substringFromIndex("code=".endIndex)截取字符串从"code="最后一个字符串开始
           let code =  query.substringFromIndex("code=".endIndex)
            print(code)
            // TODO: 换取TOKEN
        }else {
            
            //取消授权后,回到主界面
            close()
        }
        
        return false
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        print("结束")
        SVProgressHUD.dismiss()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}
