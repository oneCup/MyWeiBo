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
    
    //设置大图URL数组
    var url: [NSURL]?
    
    //设置选中状态的索引值
    var selectedIndex:Int?
    
    //重载init方法,将参数赋值
    
    init(url:[NSURL]?,selectedIndex:Int) {
    
        //设置自己的属性值
        self.url = url
        self.selectedIndex = selectedIndex
        
        //调用父类的构造函数
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.redColor()
//        setUpUI()
      }
    override func loadView() {
        var screenbounds = UIScreen.mainScreen().bounds
        screenbounds.size.width += 20
        view = UIView(frame: screenbounds)
        setUpUI()
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
        
        //保存,需要一个完成回调的方法
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
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        closeBotton.translatesAutoresizingMaskIntoConstraints = false

        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[saveButton(32)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))

        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[closeBotton(32)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[saveButton(100)]-(>=0)-[closeBotton(100)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        
        //单独准备collectionView视图
        preparCollevc()
        //注册监听通知
        saveButton.addTarget(self, action: "ClickSaveButton", forControlEvents: UIControlEvents.TouchUpInside)
        closeBotton.addTarget(self, action: "ClickCloseButton", forControlEvents: UIControlEvents.TouchUpInside)
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
    
   }



//MARK:collectionView的数据源方法

extension YFPotoBrowserController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return url!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(YFPhontoCollectionViewCell, forIndexPath: indexPath) as! YFPhotoCollectionViewCell
//        cell.backgroundColor = UIColor.randomColor()
        cell.imageURL = url![indexPath.row]
        print(url)
        return cell
    }




}
