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
//MARK:定义一个闭包的类型,也可以用枚举
typealias YFNetFinishedBack = (result: [String: AnyObject]?,error: NSError?)->()

 /// 网络访问错误信息 --是定义一组类似的值
/// swift中可以定义类似的属性和函数,和类有像

private enum YFNetWorkError: Int {
    case  emptyDataError = -1
    case  emptyTokenError = -2
//错误描述
    private var errorDescription:String {
        switch self {
            case .emptyDataError:return "空数据"
            case .emptyTokenError: return "Token为空"
        }
    }
    
//返回错误信息描述
    private func error() -> NSError {
        
        return NSError(domain: HMErrorDomainName, code:rawValue, userInfo: [HMErrorDomainName: errorDescription])
    }
}

//MARK:请求方法
private enum YFMethod: String {
    
    case GET = "GET"
    case POST = "POST"
    
}

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
    
    
/************************加载用户信息****************************/
    
// MARK: - 加载用户数据
    /// 加载用户信息 － 职责，做网络访问，获取到 dict
    /// :param: uid      用户代号字符串
    /// :param: finished 完成回调

    
    func loadUserInfo(uid:String,finished: YFNetFinishedBack) {
        
        
        guard var params = tokenDict(finished) else {
        
            return
        }
        let url = "2/users/show.json"
        
         params["uid"] = uid
  
        // 发送网络请求请求网络数据
        // 提示：如果参数不正确，首先用 option + click 确认参数类型
       request(YFMethod.GET, urlString: url, params: params, finished: finished)
       
    }
    
    
    //MARK:加载微博数据
    func loadStatus(finished:YFNetFinishedBack) {
        
        //判断Token是否为空
        guard let params = tokenDict(finished) else {
            return
        
        }
        let urlString = "2/statuses/home_timeline.json"
        
        //发送网络请求
        request(YFMethod.GET, urlString: urlString, params: params, finished: finished)
    }
    
    
//MARK:检查并生成Token字典
    private func tokenDict(finshed:YFNetFinishedBack) ->[String: AnyObject]? {
    
        //判断Token是否为空
        if YFUserAcount.sharedAcount?.access_token == nil {
        //错误回调
            let error = YFNetWorkError.emptyDataError.error()
            
        print(error)
            
            finshed(result: nil, error: error)
         
            return nil
        }
    
        return ["access_token":YFUserAcount.sharedAcount!.access_token!]
    }
    
/************************加载用户信息***************************/
    
//MARK:返回授权地址
    //返回oauth授权地址xx
    func oauthUrl() ->NSURL {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(client_id)&redirect_uri=\(redirect_uri)"
        
        let oauthUrl = NSURL(string: urlString)
        
        return oauthUrl!
    
    }
    
    
/***********************加载Token****************************/
    
 /***********************加载网络数据****************************/

    
    
//MARK:加载Token

    func loadAccessToken(code: String,finished: (result: [String: AnyObject]?,error: NSError?)->()) {

        let urlstring = "https://api.weibo.com/oauth2/access_token"
        
            let params = ["client_id":client_id,
                    "redirect_uri":redirect_uri,
                    "client_secret":appSecrect,
                    "grant_type":"authorization_code",
                    "code":code,]
        request(YFMethod.POST, urlString: urlstring, params: params, finished: finished)
    
    }
/***********************加载Token****************************/
    
    
/***********************AFN 第三方框架,网络请求方法**********************/
    
    // MARK: - 封装 AFN 网络方法，便于替换网络访问方法，第三方框架的网络代码全部集中在此
    /// AFN 网络请求 GET / POST
    ///
    /// :param: method    HTTP 方法 GET / POST
    /// :param: urlString URL 字符串
    /// :param: params    字典参数
    /// :param: finished  完成回调

    private func request(Method:YFMethod, urlString:String, params:[String:AnyObject],finished:YFNetFinishedBack) {
        //1.定义成功的闭包
        
        let sucsessCallBack:(NSURLSessionDataTask, AnyObject!) -> Void = { (_ , JSON) -> Void in
            
            if let result = JSON as? [String: AnyObject]{
                //有结果的回调
                finished(result: result, error: nil)
                
            }else {
                //没有数据同时没有结果
                print("没有数据 \(Method) Request \(urlString)")
                finished(result: nil, error: YFNetWorkError.emptyTokenError.error())
            }
        }
        
        //2.定义一个失败的闭包
        let failuredCallBack: (NSURLSessionDataTask, NSError) -> Void = {(_ , error) -> Void in
            
            finished(result: nil, error: error)
        }
        ///  根据Method来选择执行方法
        switch Method {
            
        case .GET:
            GET(urlString, parameters: params, success: sucsessCallBack, failure: failuredCallBack)
        case .POST:
            POST(urlString, parameters: params, success: sucsessCallBack, failure: failuredCallBack)
        }
        
    }
   /***********************AFN 第三方框架,网络请求方法**********************/
}
