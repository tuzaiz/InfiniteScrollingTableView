//
//  Item.swift
//  Assignment
//
//  Created by Henry Tseng on 2016/6/6.
//  Copyright © 2016年 EMQ. All rights reserved.
//

import UIKit

struct Item {
    var id : Int
    var created : NSDate
    var source : Source
    var destination : Destination
    
    /**
     Convert JSON Object from api response to Item.
     
     - parameter dataItem: JSON Object from api response.
     
     - returns: Item Object or nil if json format is incorrect.
     */
    init?(dataItem : [String:AnyObject]) {
        // Convert date format
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        // Validations and unwraps
        guard
            let id = dataItem["id"] as? Int,
            let createdTimeString = dataItem["created"] as? String,
            let created = dateFormatter.dateFromString(createdTimeString),
            let sourceComponent = dataItem["source"] as? [String:AnyObject],
            let destinationComponent = dataItem["destination"] as? [String:AnyObject]
            else {
                return nil
        }
        guard
            let sender = sourceComponent["sender"] as? String,
            let note = sourceComponent["note"] as? String
            else {
                return nil
        }
        guard
            let recipient = destinationComponent["recipient"] as? String,
            let amount = destinationComponent["amount"] as? Int,
            let currency = destinationComponent["currency"] as? String
            else {
                return nil
        }
        let source = Source(sender: sender, note: note)
        let destination = Destination(recipient: recipient, amount: amount, currency: currency)
        self.id = id
        self.created = created
        self.source = source
        self.destination = destination
    }
}

struct Source {
    var sender : String
    var note : String
}

struct Destination {
    var recipient : String
    var amount : Int
    var currency : String
}