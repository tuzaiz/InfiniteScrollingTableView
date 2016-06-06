//
//  ViewController.swift
//  Assignment
//
//  Created by Henry Tseng on 2016/6/6.
//  Copyright © 2016年 EMQ. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView : UITableView!
    var items : [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ListManager.sharedManager.updateList(20, offset: 0) { (items) in
            guard let items = items else {
                return
            }
            self.items = items
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        return cell
    }
    
}

