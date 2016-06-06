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
    var range : Range<Int> = 0..<0
    let loadingLock = NSLock()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.tableFooterView?.hidden = false
        ListManager.sharedManager.updateList(30, offset: 0) { (items) in
            guard let items = items else {
                return
            }
            self.items = items
            self.range = 0..<self.items.count
            self.tableView.reloadData()
            self.tableView.tableFooterView?.hidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadPreviousPage() {
        if self.loadingLock.tryLock() {
            self.tableView.tableHeaderView?.hidden = false
            let offset = Int(self.range.startIndex) - 10
            ListManager.sharedManager.updateList(10, offset: offset) { (items) in
                guard let items = items else {
                    return
                }
                self.items.removeRange(20..<30)
                var deleteIndexPaths = [NSIndexPath]()
                var insertIndexPaths = [NSIndexPath]()
                
                for i in 0..<10 {
                    let indexPath = NSIndexPath(forRow: i, inSection: 0)
                    insertIndexPaths.append(indexPath)
                }
                
                for i in 20..<30 {
                    let indexPath = NSIndexPath(forRow: i, inSection: 0)
                    deleteIndexPaths.append(indexPath)
                }
                
                for (idx, item) in items.enumerate() {
                    self.items.insert(item, atIndex: idx)
                }
                self.range.startIndex -= 10
                self.range.endIndex -= 10
                self.tableView.beginUpdates()
                self.tableView.deleteRowsAtIndexPaths(deleteIndexPaths, withRowAnimation: .None)
                self.tableView.insertRowsAtIndexPaths(insertIndexPaths, withRowAnimation: .None)
                self.tableView.endUpdates()
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 10, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
                self.tableView.tableHeaderView?.hidden = true
                
                self.loadingLock.unlock()
            }
        }
    }
    
    private func loadNextPage() {
        if self.loadingLock.tryLock() {
            self.tableView.tableFooterView?.hidden = false
            let offset = Int(self.range.endIndex)
            ListManager.sharedManager.updateList(10, offset: offset) { (items) in
                guard let items = items else {
                    return
                }
                self.items.removeRange(0..<10)
                var deleteIndexPaths = [NSIndexPath]()
                var insertIndexPaths = [NSIndexPath]()
                
                for i in 0..<10 {
                    let indexPath = NSIndexPath(forRow: i, inSection: 0)
                    deleteIndexPaths.append(indexPath)
                }
                
                for i in 20..<30 {
                    let indexPath = NSIndexPath(forRow: i, inSection: 0)
                    insertIndexPaths.append(indexPath)
                }
                
                for item in items {
                    self.items.append(item)
                }
                self.range.startIndex += 10
                self.range.endIndex += 10
                self.tableView.beginUpdates()
                self.tableView.deleteRowsAtIndexPaths(deleteIndexPaths, withRowAnimation: .None)
                self.tableView.insertRowsAtIndexPaths(insertIndexPaths, withRowAnimation: .None)
                self.tableView.endUpdates()
                
                self.tableView.tableFooterView?.hidden = true
                
                self.loadingLock.unlock()
            }
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if let cell = cell as? ItemCell {
            let item = self.items[indexPath.row]
            cell.setupLayout(item)
        }
        
        if indexPath.row < 3 && self.range.startIndex > 0 {
            self.loadPreviousPage()
        }
        
        if indexPath.row > 27 {
            self.loadNextPage()
        }
        
        return cell
    }
    
}

