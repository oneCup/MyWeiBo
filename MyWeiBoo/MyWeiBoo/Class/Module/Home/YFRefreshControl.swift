//
//  YFRefreshControl.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/17.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit

class YFRefreshControl: UIRefreshControl {
    
    
    override init() {
        super.init()
        setUpUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpUI() {
        //加载控件
        addSubview(refreshView)
        //设置布局
        refreshView.ff_AlignInner(type: ff_AlignType.CenterCenter, referView: self, size: refreshView.bounds.size)
    }
    
    
    //懒加载控件
    private lazy var refreshView : YFRereshView  = YFRereshView.LoadrefreshView()
}

/// 下拉刷新视图 - 负责显示动画
class YFRereshView: UIView {
    //连线属性
    
    
    //加载XIB
    class func LoadrefreshView() ->YFRereshView {
        
       return NSBundle.mainBundle().loadNibNamed("YFrefresh", owner: nil, options: nil).last as! YFRereshView
    }
    
}