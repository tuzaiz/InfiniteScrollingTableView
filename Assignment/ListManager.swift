//
//  ListManager.swift
//  Assignment
//
//  Created by Henry Tseng on 2016/6/6.
//  Copyright © 2016年 EMQ. All rights reserved.
//

import UIKit
import Alamofire

class ListManager {
    static var sharedManager = ListManager()
    
    let baseUrl = "https://hook.io/syshen/infinite-list"
    
    /**
     Get list api call
     
     - parameter number:     Total number
     - parameter offset:     Start Index
     - parameter completion: Complete callback
     */
    internal func updateList(number: Int, offset: Int, completion : ((items : [Item]?)->Void)?) {
        request(.GET, self.baseUrl, parameters: [
            "num": number,
            "startIndex": offset
            ]).responseJSON { (response) in
                guard let data = response.result.value as? [[String:AnyObject]] else {
                    completion?(items: nil)
                    return
                }
                
                var items = [Item]()
                for dataItem in data {
                    guard let item = Item(dataItem: dataItem) else {
                        continue
                    }
                    items.append(item)
                }
                
                completion?(items: items)
        }
    }
}
