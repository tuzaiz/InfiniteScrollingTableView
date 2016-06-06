//
//  ItemCell.swift
//  Assignment
//
//  Created by Henry Tseng on 2016/6/6.
//  Copyright © 2016年 EMQ. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet var senderLabel : UILabel!
    @IBOutlet var recipientLabel : UILabel!
    @IBOutlet var amountLabel : UILabel!
    @IBOutlet var noteLabel : UILabel!
    @IBOutlet var timeLabel : UILabel!
    @IBOutlet var idLabel : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupLayout(item : Item) {
        self.senderLabel.text = item.source.sender
        self.recipientLabel.text = item.destination.recipient
        self.amountLabel.text = "\(item.destination.currency) \(item.destination.amount)"
        self.noteLabel.text = item.source.note
        self.idLabel.text = "\(item.id)"
        
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .ShortStyle
        timeFormatter.timeStyle = .ShortStyle
        self.timeLabel.text = timeFormatter.stringFromDate(item.created)
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }

}
