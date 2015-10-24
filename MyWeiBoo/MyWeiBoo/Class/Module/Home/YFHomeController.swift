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
    
//        print(n)
    
        //通知监听成功
        guard let url = n.userInfo![YFstateCellDidSelectLargePicURLkey] as? [NSURL] else {
            print("图像数组不存在")
        
            return
            }
        guard let indexpath = n.userInfo![YFstateCellDidSelectIndexkey] as? NSIndexPath else {
        
            print("索引不存在")
            return
        }
        guard let pic = n.object as? YFPictureView else {
        
            print("图像不存在")
            return
        }
    
        pictureView = pic
        prensentIconVew.sd_setImageWithURL(url[indexpath.item])
        presentindexpath = indexpath
    
        //1.创建图片浏览控制器
        let picVC = YFPotoBrowserController(url:url, selectedIndex: indexpath.item)
    
        //自定义专场动画
        //默认的转场完成之后,之前的view会被移除屏幕
        //1.指定代理
        picVC.transitioningDelegate = self
        //2.指定Moda专场模式-自定义
        picVC.modalPresentationStyle = UIModalPresentationStyle.Custom
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
                self!.pullUpRefreshFlag = false
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
// MARK: - 是否Modal展现的标记
    private var isPresensented = false
    private lazy var prensentIconVew: UIImageView = {
    
    let iv = UIImageView()
        iv.contentMode = UIViewContentMode.ScaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    //转场选中的图片collectionview,可以计算起始位置的目标位置
    private var pictureView :YFPictureView?
    private var presentindexpath: NSIndexPath?
}

/// 自定义转场的协议
extension YFHomeController: UIViewControllerTransitioningDelegate {
    
    /// 返回提供转场动画的遵守 `UIViewControllerAnimatedTransitioning` 协议的对象
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresensented = true
        
        return self
    }
    
    /// 返回提供解除转场的对象
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresensented = false
        
        return self
    }
}



// MARK: - 自定义专场动画
extension YFHomeController: UIViewControllerAnimatedTransitioning {

    // 转场动画时长
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 2.0
    }
    
    // 自定义转场动画 － 只要实现了此方法，就需要自己来动画代码
    /**
    transitionContext 提供了转场动画需要的元素
    
    completeTransition(true) 动画结束后必须调用的
    containerView() 容器视图
    
    viewForKey      获取到转场的视图
    */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = prensentIconVew
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        print("fromVC----->\(fromVC)")
        print("toVC----->\(toVC)")
        
        // Modal
        if isPresensented{
            // 展现动画,最终展现的位置
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            print(toView)
            
            // 将目标视图，添加到容器视图中
            transitionContext.containerView()?.addSubview(prensentIconVew)
//            toView.alpha = 0
            //指定图像的起始位置
            let fromrect = pictureView!.cellScreenFrame(presentindexpath!)
            //指定图像的目标位置
            let toRect = self.pictureView!.cellfullScreenFrame(presentindexpath!)
            prensentIconVew.frame = fromrect
            
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                
                self.prensentIconVew.frame = toRect
                
                }) { (_) -> Void in
                    
                    self.prensentIconVew.removeFromSuperview()
                    
                    // 动画结束之后，一定要执行，如果不执行，系统会一直等待，无法进行后续的交互！
                    transitionContext.containerView()?.addSubview(toView)
                    transitionContext.completeTransition(true)
            }
            
            return
        }
            //解除照片转场动画
                let fromVCL = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! YFPotoBrowserController
        
            //从控制器中获取当前的显示的照片索引
                let indexpath = fromVCL.currentImageIndex()
            //cell对应的位置
        
                let rect = pictureView!.cellScreenFrame(indexpath)
            //照片视图
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            //设置当为视图的位置
                let IV = fromVCL.currentImageViewCell()
            //设置图像视图的位置
                IV.center = fromView!.center
            //累加父视图的形变
                let scale = fromView!.transform.a
                IV.transform = CGAffineTransformMakeScale(scale, scale)
            // 将当前图像视图，添加到容器视图
                transitionContext.containerView()?.addSubview(IV)
        
            // 将 fromView 从容器视图中移出
                fromView!.removeFromSuperview()
            //执行动画
        
                UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                    
                    //修改动画
                    IV.frame = rect
                
                    fromView!.alpha = 0.0
                
                }, completion: { (_) -> Void in
                    
                    IV.removeFromSuperview()
                    
                    // 解除转场时，会把 容器视图以及内部的内容一起销毁
                    transitionContext.completeTransition(true)
            })
    }
}
