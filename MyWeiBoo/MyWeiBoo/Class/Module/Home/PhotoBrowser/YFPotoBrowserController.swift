//
//  YFPotoBrowserController.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/19.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit
import SVProgressHUD

private let YFPhontoCollectionViewCell = "YFPhontoCollectionViewCell"

class YFPotoBrowserController: UIViewController {
    var token:dispatch_once_t = 0
    //设置大图URL数组
    var url: [NSURL]?
    
    var isOnce:Bool = true
    
    //设置选中状态的索引值
    var selectedIndex:Int?
    
    //重载init方法,将参数赋值
    
    init(url:[NSURL]?,selectedIndex:Int) {
    
        //设置自己的属性值
        self.url = url
        self.selectedIndex = selectedIndex
      print(self.url)
        //调用父类的构造函数
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor.redColor()
        
//        setUpUI()
      }
    override func loadView() {
        var screenbounds = UIScreen.mainScreen().bounds
        screenbounds.size.width += 20
        view = UIView(frame: screenbounds)
        setUpUI()
    }
    
    
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        print(self.selectedIndex!)
        print("haha")
        //解决方法1
        print(token)
        dispatch_once(&token) { () -> Void in
            let indextpath = NSIndexPath(forItem: self.selectedIndex!, inSection: 0)
            self.collectionview.scrollToItemAtIndexPath(indextpath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
            print("我来了")
        }
        
//        //2.跳转用户到指定的照片,指定一个标记符,当第一次进来之后
//        if isOnce {
//            let indextpath = NSIndexPath(forItem: selectedIndex!, inSection: 0)
//            collectionview.scrollToItemAtIndexPath(indextpath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
//            isOnce = false
//        }
        
    }
    
    
    //MARK:保存图片事件
    func ClickSaveButton() {
    
        print("保存图片")
        //1.获取照片,collectionview.indexPathsForVisibleItems().last:获取界面上所能显示的row
        let indexpath = collectionview.indexPathsForVisibleItems().last!
        let cell = collectionview.cellForItemAtIndexPath(indexpath) as! YFPhotoCollectionViewCell
        //判断图像是否存在
        guard let image = cell.ImageView.image else {
            return
        }
        
       //TODO:ERROR是怎么传的
        UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
        
      }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject?){
        
            print(error)
            print(image)
            let msg = (error == nil) ? "保存成功" : "保存失败"
            SVProgressHUD.showInfoWithStatus(msg)
    }
    
    //MARK:关闭
    func ClickCloseButton() {
    
            dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    //MARK:准备视图
    private func setUpUI() {
        
        //加载视图
        view.addSubview(collectionview)
        view.addSubview(saveButton)
        view.addSubview(closeBotton)
        let dict = ["saveButton":saveButton,"closeBotton":closeBotton,"collectionview":collectionview]
        collectionview.frame = view.bounds
        
        //设置约束
    let rect = CGRect(x: 0, y: UIScreen.mainScreen().bounds.height - 40, width: 100, height: 32)
        closeBotton.frame = CGRectOffset(rect, 8, 0)
        saveButton.frame = CGRectOffset(rect,UIScreen.mainScreen().bounds.width - rect.width - 8, 0)
        
//                view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[saveButton(32)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[closeBotton(32)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[saveButton(100)]-(>=0)-[closeBotton(100)]-28-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        
        //单独准备collectionView视图
      
        //注册监听通知
        saveButton.addTarget(self, action: "ClickSaveButton", forControlEvents: UIControlEvents.TouchUpInside)
        closeBotton.addTarget(self, action: "ClickCloseButton", forControlEvents: UIControlEvents.TouchUpInside)
          preparCollevc()
        
        
    }
    
    //MARK:准备UICollecttionView
    
    private func preparCollevc() {
    
        //注册cell
        collectionview.registerClass(YFPhotoCollectionViewCell.self, forCellWithReuseIdentifier: YFPhontoCollectionViewCell)
        //设置代理
        collectionview.dataSource = self
        
        //设置流水布局
        let layout = collectionview.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = view.bounds.size
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionview.pagingEnabled = true

    }
    
    //MARK:懒加载
    //  UICollectionView
    private lazy var collectionview = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    ///  保存按钮
    private lazy var saveButton: UIButton = {
        let btn = UIButton(title: "保存", backColor: UIColor.darkGrayColor(), fontsize: 14, textColor: UIColor.whiteColor())
        return btn;
       }()
    
    ///  关闭按钮
    private lazy var closeBotton: UIButton = {
    
        let btn = UIButton(title: "关闭", backColor: UIColor.darkGrayColor(), fontsize: 14, textColor: UIColor.whiteColor())
        return btn;
    }()
    
/// 记录缩放的比例,默认比例为1
        private var photoScale:CGFloat = 1
    
   }



//MARK:collectionView的数据源方法

extension YFPotoBrowserController: UICollectionViewDataSource,photoBrowserCellDelegete {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return url!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(YFPhontoCollectionViewCell, forIndexPath: indexPath) as! YFPhotoCollectionViewCell
//        cell.backgroundColor = UIColor.randomColor()
        cell.imageURL = url![indexPath.row]
        print(url)
        //设置缩放时代理方法
        cell.photodelegete = self
        return cell
    }
    
    func photoBrowserCellZoom(Scale: CGFloat) {
        
        print(Scale)
        photoScale = Scale
        //设置控件的隐藏
        HiddenContrl(Scale < 1)
        //开始交互转场
        if Scale < 1.0 {
            //<#T##transitionContext: UIViewControllerContextTransitioning##UIViewControllerContextTransitioning#>实现协议的对象
            startInteractiveTransition(self)
        }else {
        
            view.transform = CGAffineTransformIdentity
            view.alpha = 1.0
            
        
        }
        
    }
    //结束缩放
    func photoBrowaerEndCellZoomScale(Scale: CGFloat) {
        
        //判断缩放比例
        
        if photoScale < 0.8 {
        
        //  结束转场
            completeTransition(true)
        }else {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                
                self.view.transform = CGAffineTransformIdentity
                self.view.alpha = 1
                
                }, completion: { (_ ) -> Void in
                    
                self.photoScale = 1
                self.HiddenContrl(false)
            })
        
            
        }
    }
    
    //MARK:当前显示的图像视图
    func currentImageViewCell() ->UIImageView {
    
        let cell = collectionview.cellForItemAtIndexPath(currentImageIndex()) as! YFPhotoCollectionViewCell
        
        return cell.ImageView
    
    
    }
    
    //MARK:显示当前的照片索引
    func currentImageIndex() ->NSIndexPath {
    
        return collectionview.indexPathsForVisibleItems().last!
    }
    
    
    //MARK:隐藏控件
    func HiddenContrl(hidden: Bool) {
    
        saveButton.hidden = hidden
        closeBotton.hidden = hidden
        //设置collectionview的背景颜色
        collectionview.backgroundColor = hidden ? UIColor.clearColor() : UIColor.blackColor()
        
        
    
    }
}

extension YFPotoBrowserController:UIViewControllerInteractiveTransitioning {


    func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        view.transform = CGAffineTransformMakeScale(photoScale, photoScale)
        
        //设置透明度
        view.alpha = photoScale
    }
}

//提供转场所需要的细节

extension YFPotoBrowserController:UIViewControllerContextTransitioning {
    
    func completeTransition(didComplete: Bool) {
    
        //关闭当前的控制器{必须实现}
        dismissViewControllerAnimated(true, completion: nil)
    
    
    }


    func containerView() -> UIView? {return view.superview}
    
  
    func isAnimated() -> Bool {return true}
    
    func isInteractive() -> Bool {return true}
    
    func transitionWasCancelled() -> Bool {return false}
    
    func presentationStyle() -> UIModalPresentationStyle {return UIModalPresentationStyle.Custom}
    
    func updateInteractiveTransition(percentComplete: CGFloat) {}
    
    func finishInteractiveTransition(){}
    
    func cancelInteractiveTransition(){}
    
    func viewControllerForKey(key: String) -> UIViewController? {return self}
  
    func viewForKey(key: String) -> UIView? {return view}
    
    func targetTransform() -> CGAffineTransform {return CGAffineTransformIdentity}
    
    func initialFrameForViewController(vc: UIViewController) -> CGRect {return CGRectZero}

    func finalFrameForViewController(vc: UIViewController) -> CGRect {return CGRectZero}



}
