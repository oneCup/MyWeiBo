//
//  YFHomeController.swift
//  MyWiBo
//
//  Created by 李永方 on 15/10/7.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit


class YFHomeController: YFBaseTableViewController {
    
    var status:[YFStatues]? {
        
        didSet{
            //刷新表格数据
            
            tableView.reloadData()
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        VisitorView?.setUpViewInfo(true, imageNamed: "visitordiscover_feed_image_smallicon", messageText: "关注一些人，回这里看看有什么惊喜")
       
        prepare()
        
        //测试代码,刷新控件,高度是60
        refreshControl = UIRefreshControl()
        print(refreshControl?.bounds.height)
        
        //测试添加视图
        let v = UIView(frame: CGRect(x: 0, y: 0, width:UIScreen.mainScreen().bounds.width, height: 44))
        refreshControl?.addSubview(v)
        v.backgroundColor = UIColor.redColor()      
        //隐藏转轮
        refreshControl?.tintColor = UIColor.clearColor()
        //监听方法
        refreshControl?.addTarget(self, action: "loaddata", forControlEvents: UIControlEvents.ValueChanged)
       }
    
    //准备数据
    func prepare() {
    
//         loaddata()
        tableView.registerClass(YFStatusNormalCell.self, forCellReuseIdentifier:StatuCellIndentifier.NormalCell.rawValue)
        tableView.registerClass(YFForwardCell.self, forCellReuseIdentifier:StatuCellIndentifier.ForwardCell.rawValue)
        
        //注册原型cell
        // 设置表格的预估行高(方便表格提前计算预估行高，提高性能) - 尽量准确，能够提高性能
        // 能够减少调用行高的次数
        //        tableView.estimatedRowHeight = 300
        tableView.estimatedRowHeight = 200
        // 设置表格自动计算行高
        //        tableView.rowHeight = UITableViewAutomaticDimension
        // 取消分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
    
    }
    func loaddata() {
        
        YFNETWorkTools.sharedTools.loadStatus { (result, error) -> () in
            
            YFStatues.loadStatus({[weak self] (datalist, error) -> () in
                
                if error != nil {
                    print(error)
                    return
                }
                self?.status = datalist
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(status?.count)

        return status?.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let statuse = status![indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(StatuCellIndentifier.cellID(statuse), forIndexPath: indexPath) as! YFStateCell
        
        // 要求必须注册原型cell, storyboard，register Class
        cell.status = status![indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        //1.判断模型中是否缓存了行高
        
        let statuse = status![indexPath.row]
        
            if let h = statuse.rowHeight {
                print("缓存行高\(h)")
            return h
        
        }
        
        // 2. 获取 cell - dequeueReusableCellWithIdentifier 带 indexPath 的函数会调用计算行高的方法
        // 会造成死循环，在不同版本的 Xcode 中 行高的计算次数不一样！尽量要优化！
        // 如果不做处理，会非常消耗性能！
        
        let cell = tableView.dequeueReusableCellWithIdentifier(StatuCellIndentifier.cellID(statuse)) as? YFStateCell
        print(StatuCellIndentifier.cellID(statuse))
        
        //记录并返回行高值
        statuse.rowHeight = cell?.rowHeight(statuse)
        print( "加载行高\(statuse.rowHeight)")
        return statuse.rowHeight!
        
        
    }
    
}
