//
//  YFWelcomViewController.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/11.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit

class YFWelcomViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///MARK:准备界面
    private func prarareUI() {
    
        view.addSubview(backImageView)
        view.addSubview(iconView)
        view.addSubview(lable)
    }
    
    

    //MARK:-懒加载图片
    ///背景图片
    private lazy var backImageView: UIImageView = UIImageView(image: UIImage(named: "ad_background"))
    ///  用户头像
    private lazy var iconView: UIImageView = {
    
        let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
            
        iv.layer.masksToBounds = true
        
        iv.layer.cornerRadius = 45
        
        return iv
    }()
    
    ///  消息文字
    private lazy var lable : UILabel = {
    
        let lable = UILabel()
        lable.text = "欢迎归来"
        lable.sizeToFit()
        return lable
        
    
    
    }()
   
}
