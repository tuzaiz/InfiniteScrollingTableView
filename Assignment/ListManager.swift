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
    
    internal func updateList(number: Int, offset: Int, completion : ((items : [Item]?)->Void)?) {
        request(.GET, baseUrl, parameters: [
            "num": number,
            "startIndex": offset
            ]).responseJSON { (response) in
                guard let data = response.result.value as? [[String:AnyObject]] else {
                    return
                }
                
                // Convert date format
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                var items = [Item]()
                for dataItem in data {
                    guard
                    let id = dataItem["id"] as? Int,
                    let createdTimeString = dataItem["created"] as? String,
                    let created = dateFormatter.dateFromString(createdTimeString),
                    let sourceComponent = dataItem["source"] as? [String:AnyObject],
                        let destinationComponent = dataItem["destination"] as? [String:AnyObject] else {
                            continue
                    }
                    guard let sender = sourceComponent["sender"] as? String,
                        let note = sourceComponent["note"] as? String else {
                            continue
                    }
                    guard let recipient = destinationComponent["recipient"] as? String,
                    let amount = destinationComponent["amount"] as? Int,
                        let currency = destinationComponent["currency"] as? String else {
                            continue
                    }
                    let source = Source(sender: sender, note: note)
                    let destination = Destination(recipient: recipient, amount: amount, currency: currency)
                    let item = Item(id: id, created: created, source: source, destination: destination)
                    items.append(item)
                }
                
                completion?(items: items)
        }
    }
}
