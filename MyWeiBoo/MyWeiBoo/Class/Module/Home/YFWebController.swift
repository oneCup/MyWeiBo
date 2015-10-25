//
//  YFWebController.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/25.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit
import SVProgressHUD

class YFWebController: UIViewController,UIWebViewDelegate {
    
    ///  要加载的url
    var url: NSURL?
    
    override func loadView() {
        super.loadView()
        view = webView
        webView.delegate = self
        webView.frame = UIScreen.mainScreen().bounds
        webView.backgroundColor = UIColor.redColor()
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "网页"
        //加载URL
        if url != nil {
        
            webView.loadRequest(NSURLRequest(URL: url!))
        }

    }
    
    // MARK: 代理方法
    
    func webViewDidStartLoad(webView: UIWebView) {
        
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        SVProgressHUD.dismiss()
    }

    
    //  MARK:懒加载
    
    private lazy var webView = UIWebView()
   

}
