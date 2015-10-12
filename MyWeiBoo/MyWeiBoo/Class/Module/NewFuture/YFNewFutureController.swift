//
//  YFNewFutureController.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/11.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class YFNewFutureController: UICollectionViewController {

    ///  定义图片的总数
    private let imagCount = 4
    
    ///  布局属性
    private let layout = YFFlowLayout()
    
    init() {
    
        super.init(collectionViewLayout: layout)
    
    }

    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder:aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.collectionView!.registerClass(NewFeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }
    
    
    
    // MARK: UICollectionViewDataSource

    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return imagCount
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NewFeatureCell
        
        cell.imageIndex = indexPath.item
        print("item\(indexPath.item)")
    
        return cell
    }
    
 // 新特性界面的加载cell
 /// 完成显示cell -indexPath是之前消失cell的indexpath
    
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        print("indexPath\(indexPath)")
        //判断是否是末尾的 indexPath
        let path = collectionView.indexPathsForVisibleItems().last!
        
        print("path-->\(path.item)")
        
        if path.item == imagCount-1 {
        //播放动画
        let cell = collectionView.cellForItemAtIndexPath(path) as! NewFeatureCell
        cell.startButtonAnimi()
            
        }
    }
    class NewFeatureCell: UICollectionViewCell {
        
    //图像索引-私有属性,在同一个文件中,是允许访问的
    private var imageIndex: Int = 0 {
    
        didSet{
            
            IconView.image = UIImage(named: "new_feature_\(imageIndex + 1)")
            startButton.hidden = true
        }
    }
    
    //设置UI
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareUI()
    }
    //MARK:开始按钮的点击
    func clickStartButton(){
        
        NSNotificationCenter.defaultCenter().postNotificationName(YFRootViewControollerSwithNotifacation, object: true)
        }
        
    //MARK: 开始动画
    private func startButtonAnimi () {
            
        //使用transform进行动画设置
        startButton.hidden = false
        //设置从0开始缩放
        startButton.transform = CGAffineTransformMakeScale(0, 0)
        //开始动画
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            
            //回复还原位置
            self.startButton.transform = CGAffineTransformMakeScale(1, 1)
            }) { (_) -> Void in
                
             //设置按钮可用
            self.startButton.userInteractionEnabled = true
        }
            
        }

    
    ///  准备控件
    private func prepareUI() {
        contentView.addSubview(IconView)
        contentView.addSubview(startButton)
        //自动布局
        IconView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[subView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["subView":IconView]))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[subview]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["subview": IconView]))
        
        //设置label布局
        startButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -100))
        contentView.addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.CenterX, relatedBy:NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
    }

    ///MARK: 懒加载控件
    private lazy var IconView  =  UIImageView()
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "new_feature_finish_button"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "new_feature_finish_button_highlighted"), forState: UIControlState.Highlighted)
        button.setTitle("开始体验", forState: UIControlState.Normal)

        
        //根据背景图片自动调整大小
        button.hidden = true
        button.addTarget(self, action: "clickStartButton", forControlEvents: UIControlEvents.TouchUpInside)
        button.userInteractionEnabled = false
        return button
        
        }()
}
    
    private class YFFlowLayout:UICollectionViewFlowLayout {
    
        //创建一个layout属性
        let FlowLayOut = UICollectionViewFlowLayout()
        
            override func prepareLayout() {
           itemSize = collectionView!.bounds.size
            minimumInteritemSpacing = 0
            minimumLineSpacing = 0
            scrollDirection = UICollectionViewScrollDirection.Horizontal
            
            collectionView?.pagingEnabled = true
            collectionView?.showsHorizontalScrollIndicator = false
            collectionView?.bounces = false
            
        }
}
}
