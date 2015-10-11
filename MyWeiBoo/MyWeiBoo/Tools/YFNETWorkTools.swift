//
//  YFNETWorkTools.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/10.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit
import AFNetworking
/// 错误的类别标记
private let HMErrorDomainName = "com.itheima.error.network"

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
///  封装AFN的方法
    /*
    便于网络访问
    */
   
    //定义一个闭包的类型,也可以用枚举
    typealias YFNetFinishedBack = (result: [String: AnyObject]?,error: NSError?)->()
    
    /// GET 请求
    ///
    /// :param: urlString URL 地址
    /// :param: params    参数字典
    /// :param: finished  完成回调
    private func RequestGet(urlString:String,params:[String],finished:YFNetFinishedBack){
        
    GET(urlString, parameters: params, success: { (_ , JSON) -> Void in
        
        if let result = JSON as? [String: AnyObject]{
        //有结果的回调
            finished(result: result, error: nil)
        }else{
            print("没有数据 GET Request \(urlString)")
            // 没有错误，同时没有结果
            print("没有数据 GET Request \(urlString)")
            /**
            domain: 错误的范围/大类别，定义一个常量字符串
            code: 错误代号，有些公司会专门定义一个特别大的.h，定义所有的错误编码，通常是负数
            userInfo: 可以传递一些附加的错误信息
            */
            let error = NSError(domain: HMErrorDomainName, code: -1, userInfo: ["errorMessage": "空数据"])
            finished(result: nil, error: error)
        }
        
    }) { (_ , error) -> Void in
            
            print(error)
            finished(result: nil, error: error)
        }
    
    }
    
}
