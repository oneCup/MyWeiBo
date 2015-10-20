//
//  YFPhotoCollectionViewCell.swift
//  MyWeiBoo
//
//  Created by 李永方 on 15/10/19.
//  Copyright © 2015年 李永方. All rights reserved.
//

import UIKit

class YFPhotoCollectionViewCell: UICollectionViewCell {
    
    //设置属性
    var imageURL: NSURL? {
    
        didSet{
            
            indicator.startAnimating()
            
            ///  加载数据之前清除缓存
            ImageView.image = nil
            
            ImageView.sd_setImageWithURL(imageURL) { (image, _ , _ , _) -> Void in
            
            if self.imageURL == nil {
                print("没有图片")
                return
            }
            self.setImagePosition()
            self.indicator.stopAnimating()
                

            
            }
            
        }
    }
    
    //MARK:重写创建cell的方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        preparUI()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:设置图像的位置:判断长短图
    private func setImagePosition() {
        
        //判断是否为长短图
        let size = setDiaplaySize(ImageView.image!)
        if size.height > scroolView.bounds.size.height {//大图
            ImageView.frame = CGRect(origin: CGPointZero, size: size)
            //为了时图片可以滚动
            scroolView.contentSize = size
        }else {//短图
            //垂直居中
            let  y = (scroolView.bounds.height - size.height) * 0.5
        
            ImageView.frame = CGRect(origin: CGPoint(x: 0, y: y), size: size)
        }
        
        
    }

    
    //MARK:设置图片的尺寸:以scorllView宽度为基准
    private func setDiaplaySize(image:UIImage)->CGSize {
    
        //设置缩放比例
        
        let scale =  image.size.height / image.size.width
        let width = scroolView.bounds.size.width
        let height = width * scale
        return CGSize(width: width, height: height)
  
    }
    
    //MARK:准备UI界面
    private func preparUI() {
    
        //加载控件
        contentView.addSubview(scroolView)
        scroolView.addSubview(ImageView)
        ImageView.frame = CGRectMake(0, 0, 90, 90)
        contentView.addSubview(indicator)

        scroolView.backgroundColor = UIColor.blackColor()
        print(scroolView.subviews)
        
        //布局
        scroolView.translatesAutoresizingMaskIntoConstraints = false
        indicator.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[sv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["sv":scroolView]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[sv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["sv":scroolView]))
            addConstraint(NSLayoutConstraint(item: indicator, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
            addConstraint(NSLayoutConstraint(item: indicator, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
    
    }
    //MARK:懒加载
    /// SCROLL
    private lazy var scroolView = UIScrollView()
    ///  图像url
    private lazy var ImageView = UIImageView()
    ///  网络加载动画
    private lazy var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    
    }
