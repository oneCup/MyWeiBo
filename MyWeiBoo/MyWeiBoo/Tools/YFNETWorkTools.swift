//
//  YFNETWorkTools.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/10.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit
import AFNetworking

class YFNETWorkTools: AFHTTPSessionManager {
    
    //单例
    static let sharedTools: YFNETWorkTools = {
        let baseUrl = NSURL(string: "https://api.weibo.com/")!
        let tools = YFNETWorkTools(baseURL: baseUrl)
        return tools
    
    }()
    
    //MARK:授权信息
    private let client_id = "2121649528"
    private let appSecrect = "5ad64f5c54623fecbf50ebb329d846e5"
    let redirect_uri = "http://www.baidu.com"
    //返回oauth授权地址
    func oauthUrl() ->NSURL {
    let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(client_id)&redirect_uri=\(redirect_uri)"
        
        let oauthUrl = NSURL(string: urlString)
        
        return oauthUrl!
    
    }
}
