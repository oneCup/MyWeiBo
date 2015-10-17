//
//  YFRefreshControl.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/17.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit

/// frame的Y的临界值
let krefreshPullOffset: CGFloat = -60

class YFRefreshControl: UIRefreshControl {
    
    
    override init() {
        super.init()
        setUpUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
///  加入了KVO必须将KVO进行移除
    deinit {
        //KVO监听frame 的属性变化
        self.removeObserver(self, forKeyPath: "frame")
     }
    
    //打印方法
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        print(frame)
        if frame.origin.y < krefreshPullOffset && !refreshView.Refreshflag {
            
            //设置属性的标记
            refreshView.Refreshflag = true
            
        }else if frame.origin.y > krefreshPullOffset && refreshView.Refreshflag{
            
            refreshView.Refreshflag = false
        }
    }

    private func setUpUI() {
        //监听属性值的变化kvo frame的变化
        self.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
        
        tintColor = UIColor.clearColor()
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
    
    @IBOutlet weak var TipIcon: UIImageView!
    
    @IBOutlet weak var RefreshIcon: UILabel!
    
    @IBOutlet weak var LoadingIcon: UIImageView!
    
    @IBOutlet weak var TipView: UIView!
    //定义旋转标记
    var Refreshflag = false {
        
        didSet {
            //每次监听到属性值变化,就会旋转
            rotateTip()
        }
  
    }
    
    //加载XIB
    class func LoadrefreshView() ->YFRereshView {
        
       return NSBundle.mainBundle().loadNibNamed("YFrefresh", owner: nil, options: nil).last as! YFRereshView
    }
    
    ///  旋转图片
    private func rotateTip() {
    
        let angle = Refreshflag ? CGFloat(M_PI - 0.01) : CGFloat(M_PI + 0.01)
        UIView.animateWithDuration(1.0) { () -> Void in
            
            //判断旋转标记
            self.TipIcon.transform = CGAffineTransformRotate(self.TipIcon.transform, angle)
        }
    }
    
}