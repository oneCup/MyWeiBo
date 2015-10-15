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
        
        //注册原型cell
       
        VisitorView?.setUpViewInfo(true, imageNamed: "visitordiscover_feed_image_smallicon", messageText: "关注一些人，回这里看看有什么惊喜")
        loaddata()
        tableView.registerClass(YFStateCell.self, forCellReuseIdentifier: "Cell")
        // 设置表格的预估行高(方便表格提前计算预估行高，提高性能) - 尽量准确，能够提高性能
        // 能够减少调用行高的次数
//        tableView.estimatedRowHeight = 300
        tableView.estimatedRowHeight = 200
        // 设置表格自动计算行高
        tableView.rowHeight = UITableViewAutomaticDimension
        // 取消分割线
//        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
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

        return status?.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! YFStateCell
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? YFStateCell
        //记录并返回行高值
        statuse.rowHeight = cell?.rowHeight(statuse)
        print( statuse.rowHeight)
        
        return statuse.rowHeight!
        
    }
    
}
