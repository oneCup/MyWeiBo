//
//  YFPictureView.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/15.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit
import SDWebImage

let YFstateCellDidSelectNotification = "YFstateCellDidSelectNotification"
let YFstateCellDidSelectLargePicURLkey = "YFstateCellDidSelectLargePicURLkey"
let YFstateCellDidSelectIndexkey = "YFstateCellDidSelectIndexkey"

/// 可重用 cell 标示符
private let statusPictureViewCellID = "statusPictureViewCellID"

class YFPictureView: UICollectionView{
    
    var status: YFStatues? {
    
        didSet{
            sizeToFit()
            //刷新视图
            reloadData()
        }
    }
    override func sizeThatFits(size: CGSize) -> CGSize {
        return calViewSize()
    }
    //MARK:构造函数
    
    //计算图面的行高
    func calViewSize()->CGSize {
    //准备常量
        let itmSize = CGSize(width: 90, height: 90)
        let margin : CGFloat = 10
        //每行中最多显示的数量
        let rowCount = 3
        pictureLayOut.itemSize = itmSize
        //根据图片数量来计算视图大小
        let count = status?.PictursURL?.count ?? 0
            //1>没有图片
        if count == 0 {
        return CGSizeZero
        }
        
        if count == 1 {
            let key = status!.PictursURL![0].absoluteString
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key)
            //判断为空
            //如果图像不存在的大小
            var size = CGSize(width: 90, height: 90)
            
            if image != nil {
                size = image.size
            }
            //对图像的尺寸进行判断,解决图片的过宽,过窄的情况
            size.width = size.width < 40 ? 40 : size.width
            size.width = size.width > UIScreen.mainScreen().bounds.width ? 150 : size.width
            
            pictureLayOut.itemSize = size
            
            return size
        }
        if count == 4 {
        let w = itmSize.width * 2 + margin
            return CGSize(width: w, height: w)
        }
        //TODO:有没有简便的方法
        let row = (count - 1) / rowCount + 1
        let w = itmSize.width * CGFloat(rowCount) + margin * CGFloat(rowCount - 1)
        let h = itmSize.height * CGFloat(row) + margin * CGFloat(row - 1)
        return CGSize(width: w, height: h)
    }
///  图片布局
    
    private let pictureLayOut = UICollectionViewFlowLayout()
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: pictureLayOut)
        backgroundColor = UIColor.lightGrayColor()
        //注册重用cell
        // 注册可重用 cell
        registerClass(YFPictureViewCell.self, forCellWithReuseIdentifier: statusPictureViewCellID)
        self.dataSource = self
        self.delegate = self
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 }

//在 swift 中，协议同样可以通过 extension 遵守协议并实现方法来写，可以将一组协议方法，放置在一起，便于代码维护和阅读！
extension YFPictureView: UICollectionViewDataSource,UICollectionViewDelegate {
    
    /// 选中某一行的代理通知(当选中某一行时)
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        print(indexPath)
        //获取大图url
        //选中cell的行后,发送通知
        NSNotificationCenter.defaultCenter().postNotificationName(YFstateCellDidSelectNotification, object: nil, userInfo: [YFstateCellDidSelectLargePicURLkey:status!.LargePicURL!,YFstateCellDidSelectIndexkey:indexPath])
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return status?.PictursURL?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(statusPictureViewCellID, forIndexPath: indexPath) as!YFPictureViewCell
//        cell.backgroundColor = UIColor.redColor()
        
        cell.imageURL = status!.PictursURL![indexPath.item]
        
        return cell
    }
}


class YFPictureViewCell: UICollectionViewCell {
    
    var imageURL:NSURL? {
    
        didSet{
        
        iconView.sd_setImageWithURL(imageURL)

        }
    }
    //MARK:构造函数
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        SetUpUI()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //加载cell中的控件
    func SetUpUI () {
    
        contentView.addSubview(iconView)
        iconView.ff_Fill(contentView)
    
    }
    
//懒加载视图控件
    private lazy var iconView: UIImageView = {
    
        let iconView = UIImageView()
        //设置图片的的内容模式
        iconView.contentMode = UIViewContentMode.ScaleAspectFill
        //超出的边缘剪切掉
        iconView.clipsToBounds = true
        
        return iconView
    
    }()
    
}
