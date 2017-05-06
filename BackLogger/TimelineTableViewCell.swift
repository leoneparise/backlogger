//
//  TimelineTableViewCell.swift
//  StumpExample
//
//  Created by Leone Parise Vieira da Silva on 06/05/17.
//  Copyright © 2017 com.leoneparise. All rights reserved.
//

import UIKit

public class TimelineTableViewCell: UITableViewCell {
    @IBOutlet weak var typeLabel:LogTypeLabel!
    @IBOutlet weak var fileLabel:UILabel!
    @IBOutlet weak var lineLabel:UILabel!
    @IBOutlet weak var messageLabel:UILabel!
    @IBOutlet weak var dateLabel:UILabel!
    
    public var line:UInt? {
        didSet { lineLabel.text = line != nil ? "\(line!)" : "" }
    }
    
    public var message:String? {
        didSet { messageLabel.text = message }
    }
    
    public var file:String? {
        didSet { fileLabel.text = file }
    }
    
    public var type:LogType = .debug {
        didSet { typeLabel.type = type }
    }
    
    public var createdAt:Date = Date() {
        didSet { dateLabel.text = String(format: "%02d", createdAt.second) }
    }
}