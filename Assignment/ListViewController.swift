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
    
    var items = [Item]() // Shown items
    var range : Range<Int> = 0..<0 // Record the range of index
    let loadingLock = NSLock() // Lock to avoid concurrency issue.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.initialList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Update list
    private func initialList() {
        self.tableView.tableFooterView?.hidden = false
        ListManager.sharedManager.updateList(30, offset: 0) { (items) in
            guard let items = items else {
                let alert = UIAlertController(title: nil, message: "API Request Failure", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Reload", style: .Cancel, handler: { _ in
                    self.initialList()
                }))
                self.presentViewController(alert, animated: true, completion: nil)
                self.tableView.tableFooterView?.hidden = true
                return
            }
            
            // Update list by response
            self.items = items
            self.range = 0..<self.items.count
            self.tableView.reloadData()
            self.tableView.tableFooterView?.hidden = true
        }
    }
    
    private func loadPreviousPage() {
        // Use lock to avoid concurrency loading issue.
        if self.loadingLock.tryLock() {
            self.tableView.tableHeaderView?.hidden = false // Show loading indicator in header.
            let offset = Int(self.range.startIndex) - 10
            ListManager.sharedManager.updateList(10, offset: offset) { (items) in
                guard let items = items else {
                    self.loadingLock.unlock()
                    self.tableView.tableHeaderView?.hidden = true
                    let alert = UIAlertController(title: nil, message: "API Request Failure", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    return
                }
                
                // Update items
                self.items.removeRange(20..<30)
                for (idx, item) in items.enumerate() {
                    self.items.insert(item, atIndex: idx)
                }
                self.range.startIndex -= items.count
                self.range.endIndex -= items.count
                
                // Update table view
                var deleteIndexPaths = [NSIndexPath]()
                var insertIndexPaths = [NSIndexPath]()
                
                for i in 0..<items.count {
                    let insertIndexPath = NSIndexPath(forRow: i, inSection: 0)
                    insertIndexPaths.append(insertIndexPath)
                    
                    let deleteIndexPath = NSIndexPath(forRow: i + 20, inSection: 0)
                    deleteIndexPaths.append(deleteIndexPath)
                }
                
                self.tableView.beginUpdates()
                self.tableView.deleteRowsAtIndexPaths(deleteIndexPaths, withRowAnimation: .None)
                self.tableView.insertRowsAtIndexPaths(insertIndexPaths, withRowAnimation: .None)
                self.tableView.endUpdates()
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 10, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
                
                // Dismiss loading indicator in header
                self.tableView.tableHeaderView?.hidden = true
                
                self.loadingLock.unlock()
            }
        }
    }
    
    private func loadNextPage() {
        // Use lock to avoid concurrency loading issue.
        if self.loadingLock.tryLock() {
            self.tableView.tableFooterView?.hidden = false // Show loading indicator in footer.
            let offset = Int(self.range.endIndex)
            ListManager.sharedManager.updateList(10, offset: offset) { (items) in
                guard let items = items else {
                    self.loadingLock.unlock()
                    self.tableView.tableFooterView?.hidden = true
                    let alert = UIAlertController(title: nil, message: "API Request Failure", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    return
                }
                
                // Update items
                self.items.removeRange(0..<10)
                for item in items {
                    self.items.append(item)
                }
                
                // Move offsets
                self.range.startIndex += items.count
                self.range.endIndex += items.count
                
                // Update table view
                var deleteIndexPaths = [NSIndexPath]()
                var insertIndexPaths = [NSIndexPath]()
                
                for i in 0..<items.count {
                    let deleteIndexPath = NSIndexPath(forRow: i, inSection: 0)
                    deleteIndexPaths.append(deleteIndexPath)
                    
                    let insertIndexPath = NSIndexPath(forRow: i + 20, inSection: 0)
                    insertIndexPaths.append(insertIndexPath)
                }
                
                self.tableView.beginUpdates()
                self.tableView.deleteRowsAtIndexPaths(deleteIndexPaths, withRowAnimation: .None)
                self.tableView.insertRowsAtIndexPaths(insertIndexPaths, withRowAnimation: .None)
                self.tableView.endUpdates()
                
                // Dismiss loading indicator in footer.
                self.tableView.tableFooterView?.hidden = true
                
                self.loadingLock.unlock()
            }
        }
    }

    // MARK: - TableView DataSource
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
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row < 3 && self.range.startIndex > 0 {
            self.loadPreviousPage()
        }
        
        if indexPath.row > 27 {
            self.loadNextPage()
        }
    }
    
}

