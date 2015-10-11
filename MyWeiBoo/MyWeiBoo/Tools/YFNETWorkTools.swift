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
    
    //应用程序信息
    //MARK:授权信息
    private let client_id = "2121649528"
    private let appSecrect = "5ad64f5c54623fecbf50ebb329d846e5"
    let redirect_uri = "http://www.baidu.com"
    
    //单例
    static let sharedTools: YFNETWorkTools = {
        let baseUrl = NSURL(string: "https://api.weibo.com/")!
        let tools = YFNETWorkTools(baseURL: baseUrl)
        //设置解析数据类型
        tools.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript","text/plain") as Set<NSObject>
        return tools
    
    }()
    
    
    //返回oauth授权地址
    func oauthUrl() ->NSURL {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(client_id)&redirect_uri=\(redirect_uri)"
        
        let oauthUrl = NSURL(string: urlString)
        
        return oauthUrl!
    
    }
    
   ///加载Token
    func loadAccessToken(code: String,finished: (result: [String: AnyObject]?,error: NSError?)->()) {

        let urlstring = "https://api.weibo.com/oauth2/access_token"
        
            let params = ["client_id":client_id,
                    "redirect_uri":redirect_uri,
                    "client_secret":appSecrect,
                    "grant_type":"authorization_code",
                    "code":code,]
        
            POST(urlstring, parameters: params, success: { (_, JSON) -> Void in
                
                print(JSON)
                
                finished(result:JSON as? [String: AnyObject],error:nil)
                
                }) { (_, error) -> Void in
                    
                    print(error)
                finished(result: nil, error: error)
                    
        }
        
        
        }
    
}
