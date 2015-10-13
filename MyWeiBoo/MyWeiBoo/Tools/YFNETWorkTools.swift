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

 /// 网络访问错误信息 --是定义一组类似的值
/// swift中可以定义类似的属性和函数,和类有像

private enum YFNetWorkError: Int {

    case  emptyDataError = -1
    case  emptyTokenError = -2
//错误描述
    private var errorDescription:String {
    
        switch self {
        
            case .emptyDataError:return "空数据"
            case.emptyTokenError: return "Token为空"
        }
    }
    
//返回错误信息描述
    private func error() -> NSError {
        
        return NSError(domain: HMErrorDomainName, code:rawValue, userInfo: [HMErrorDomainName: errorDescription])
    }
}


class YFNETWorkTools: AFHTTPSessionManager {
    
    //应用程序信息
    //MARK:授权信息
    private let client_id = "2121649528"
    private let appSecrect = "5ad64f5c54623fecbf50ebb329d846e5"
    let redirect_uri = "http://www.baidu.com"
    //MARK:定义一个闭包的类型,也可以用枚举
    typealias YFNetFinishedBack = (result: [String: AnyObject]?,error: NSError?)->()
    //单例
    static let sharedTools: YFNETWorkTools = {
        let baseUrl = NSURL(string: "https://api.weibo.com/")!
        let tools = YFNETWorkTools(baseURL: baseUrl)
        //设置解析数据类型
        tools.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript","text/plain") as Set<NSObject>
        return tools
    
    }()
    
 
//MARK:封装AFN GET方法
/************************封装AFN GET方法****************************/
    
    /// GET 请求
    ///
    /// :param: urlString URL 地址
    /// :param: params    参数字典
    /// :param: finished  完成回调
    private func RequestGet(urlString:String,params:[String:AnyObject],finished:YFNetFinishedBack){
        
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

    
    // MARK: - 加载用户数据
    
/************************加载用户信息****************************/
    
    /// 加载用户信息 － 职责，做网络访问，获取到 dict
    /// :param: uid      用户代号字符串
    /// :param: finished 完成回调
    
    func loadUserInfo(uid:String,finished: YFNetFinishedBack) {
        // 判断沙盒中Token是否存在
        if YFUserAcount.sharedAcount?.access_token == nil {
            
            //回调错误,token为空
            let error = YFNetWorkError.emptyTokenError.error()
            print(error)
            finished(result: nil, error: YFNetWorkError.emptyTokenError.error())
            return;
        }
        let url = "2/users/show.json"
        //向服务器发送请求
        let params: [String: AnyObject] = ["access_token": YFUserAcount.sharedAcount!.access_token!, "uid": uid]
        // 发送网络请求请求网络数据
        // 提示：如果参数不正确，首先用 option + click 确认参数类型
       RequestGet(url, params: params, finished: finished)
    }
    
//MARK:返回授权地址
    //返回oauth授权地址xx
    func oauthUrl() ->NSURL {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(client_id)&redirect_uri=\(redirect_uri)"
        
        let oauthUrl = NSURL(string: urlString)
        
        return oauthUrl!
    
    }
    
//MARK:加载Token
    func loadAccessToken(code: String,finished: (result: [String: AnyObject]?,error: NSError?)->()) {

        let urlstring = "https://api.weibo.com/oauth2/access_token"
        
            let params = ["client_id":client_id,
                    "redirect_uri":redirect_uri,
                    "client_secret":appSecrect,
                    "grant_type":"authorization_code",
                    "code":code,]
        
            POST(urlstring, parameters: params, success: { (_, JSON) -> Void in
                
                print("NET------>\(__FUNCTION__)+\(JSON)")
                finished(result:JSON as? [String: AnyObject],error:nil)
                }) { (_, error) -> Void in
                    print(error)
                finished(result: nil, error: error)
        }
        
        }
}
