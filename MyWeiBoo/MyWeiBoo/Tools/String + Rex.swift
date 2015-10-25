//
//  String + Rex.swift
//  正则表达式
//
//  Created by 李永方 on 15/10/25.
//  Copyright © 2015年 李永方. All rights reserved.
//

import Foundation

extension String {
    
    func hrefLink() ->(link: String? , text: String?) {


        let pattern = "<a href=\"(.*?)\".*?>(.*?)</a>"
        let regular = try! NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.DotMatchesLineSeparators)
        
        //开始匹配
        if let result = regular.firstMatchInString(self, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) {
        print(result.numberOfRanges)
        
            //let r1 = result!.rangeAtIndex(0)
            let r2 = result.rangeAtIndex(1)
            let r3 = result.rangeAtIndex(2)
            let link = (self as NSString).substringWithRange(r2)
            let text = (self as NSString).substringWithRange(r3)
            
            return (link,text)
        }
        
        return(nil,nil)
        
  
    }
    





}
