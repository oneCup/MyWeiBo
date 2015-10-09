//
//  AppDelegate.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/8.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //设置外观对象,一旦设置全局共享,越早设置越好
        setApperance()
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        window?.backgroundColor = UIColor.redColor()
        
        window?.rootViewController = YFMainController()
        
        window?.makeKeyAndVisible()

        // Override point for customization after application launch.
        return true
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

