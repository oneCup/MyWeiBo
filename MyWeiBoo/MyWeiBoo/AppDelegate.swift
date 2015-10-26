//
//  AppDelegate.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/8.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit
let YFRootViewControollerSwithNotifacation = "YFRootViewControollerSwithNotifacation"

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        SQLiteManager.sharedManager
         print(NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!.stringByAppendingString("/account.plist"))
        
        //注册一个通知中心
        
       NSNotificationCenter.defaultCenter().addObserver(self, selector: "switchViewController:", name: YFRootViewControollerSwithNotifacation, object: nil)
//        print(YFUserAcount.sharedAcount)
        //设置外观对象,一旦设置全局共享,越早设置越好
        setApperance()
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = defultViewController()
        window?.makeKeyAndVisible()
        
       
        return true
    }
    
    //程序结束才会被只执行,不写不会影响程序的执行,因为通知也是一个单例
    deinit {
    //注销一个通知 - 知识一个习惯
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    ///  切换控制器(通过通知实现)
    func switchViewController(n:NSNotification) {

        print("切换控制器\(n)")
        //判断是否为true
        let mainVC = n.object as! Bool
        print(mainVC)
        window?.rootViewController = mainVC ? YFMainController() : YFWelcomViewController()
        
     }
    
    ///  返回默认的控制器
    private func defultViewController() -> UIViewController {
        
        //1.判断用户,没有登录则进入主界面
        if !YFUserAcount.userLogin {
            return YFMainController()
        }
        //2.判断是否有更新版本,有,则进入新特性界面,没有则进入欢迎界面
        return isUpDateVersion() ? YFNewFutureController() : YFWelcomViewController()
    }
    
///  判断版本号
    
    func isUpDateVersion()->Bool {
    
        //1.获取软件的版本号
        let currentVersion = Double(NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String)!
        //2.获取沙盒文件中的版本号
        //2.1设置软件版本的key
        let sandBoxVersionkey = "sandBoxVersionkey"
        //2.2 从沙盒中获取版本
        let sandBoxVersion = NSUserDefaults.standardUserDefaults().doubleForKey(sandBoxVersionkey)
        //2.3将版本存放在沙盒中
        NSUserDefaults.standardUserDefaults().setDouble(currentVersion, forKey: sandBoxVersionkey)
        //3.返回比较结果
        return currentVersion > sandBoxVersion
    
    }
    
    //设置外观对象
    func setApperance() {
        
        //获取外观单例对象并设置代理
        
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

