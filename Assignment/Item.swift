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