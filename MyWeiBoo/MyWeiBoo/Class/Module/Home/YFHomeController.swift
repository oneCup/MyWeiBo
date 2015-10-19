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
        if !YFUserAcount.userLogin {
        VisitorView?.setUpViewInfo(true, imageNamed: "visitordiscover_feed_image_smallicon", messageText: "关注一些人，回这里看看有什么惊喜")
            return
        }
        ///MARK:  注册一个通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "selectPicture:", name: YFstateCellDidSelectNotification, object: nil)
        prepare()
        loaddata()
        
       }
    
    deinit {
        //注册通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK:选择照片
   @objc private  func selectPicture(n:NSNotification) {
        
        //通知监听成功
    guard let url = n.userInfo![YFstateCellDidSelectLargePicURLkey] as? [NSURL] else {
        print("图像数组不存在")
    
        return
        }
    guard let indexpath = n.userInfo![YFstateCellDidSelectIndexkey] as? NSIndexPath else {
    
        print("索引不存在")
        return
    }
        //1.创建图片浏览控制器
        let picVC = YFPotoBrowserController(url:url, selectedIndex: indexpath.item)
    
        presentViewController(picVC, animated: true, completion: nil)
    
        
    }
    
    //准备数据
    func prepare() {
    
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
        //测试代码,刷新控件,高度是60
        refreshControl = YFRefreshControl()
        //隐藏转轮
        refreshControl?.tintColor = UIColor.clearColor()
        //监听方法
        refreshControl?.addTarget(self, action: "loaddata", forControlEvents: UIControlEvents.ValueChanged)
        
    
    }
    ///  定义一个上拉刷新的标记
    private var pullUpRefreshFlag = false
    func loaddata() {
        
        //开启刷新动画,但并不会加载数据
        refreshControl?.beginRefreshing()
        //复位保证下次可以继续上拉
        
        self.pullUpRefreshFlag = false
        
        //刷新数据,获取每一条数据的id
        //第一次执行词方法方法的时候,status为空,sinc_id = o加载最新的20条数据
        var since_id = status?.first?.id ?? 0
        var max_id = 0
        //判断是否是上拉数据
        if pullUpRefreshFlag {
            since_id = 0
            //做下拉刷新
            max_id = status?.last?.id ?? 0
        }
    
            YFStatues.loadStatus(since_id,max_id: max_id){[weak self] (datalist, error) -> () in
                self!.refreshControl?.endRefreshing()
                if error != nil {
                    print(error)
                    return
                }
                let count = datalist?.count ?? 0
                print("刷新到\(count)数据")
                if since_id > 0 {
                
                self!.shownPullDdown(count)
                    
                }
                
                //判断是否有数据
                if count == 0 {
                    return
                }
                //下拉刷新,将结果集放在集合的前面
                if since_id > 0 {
                    self!.status = datalist! + self!.status!
                    
                }else if max_id > 0{    //上拉数据
                    self!.status! += datalist!
                   
                }else {
                    self?.status = datalist
                }
            }
    }
    ///  显示上拉刷新提示
    private func shownPullDdown(count: Int) {
    
        //定义标签
        let h: CGFloat = 44
        let label = UILabel(frame: CGRectMake(0, -2 * h, UIScreen.mainScreen().bounds.width, h))
        label.backgroundColor = UIColor.orangeColor()
        label.text = "刷新了\(count)条数据"
        label.textAlignment = NSTextAlignment.Center
        // 将 label 添加到界面(view不合适，会一起滚动)
        // 加载 navBar 上面，不会随着 tableView 一起滚动
//        view.insertSubview(label, atIndex: 0)
        navigationController?.navigationBar.insertSubview(label, atIndex: 0)
        //加载动画
       UIView.animateWithDuration(1, animations: { () -> Void in
        
            //自动翻转动画
            UIView.setAnimationRepeatAutoreverses(true)
            //移动label的位置
            label.frame = CGRectOffset(label.frame, 0, 3 * h)
        
        }) { (_) -> Void in
            
            //移除动画
            label.removeFromSuperview()
        }
    }
    
       // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(status?.count)

        return status?.count ?? 0
    }

    //每次要显示cell的时候,会调用此方法,根据数据源方法
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let statuse = status![indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(StatuCellIndentifier.cellID(statuse), forIndexPath: indexPath) as! YFStateCell
        
        //判断indexpath.row是否是最后一行,如果是则进行上拉数据
        if indexPath.row == status!.count - 1 {
            pullUpRefreshFlag = true
            //开始上拉数据
            loaddata()
        }
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
