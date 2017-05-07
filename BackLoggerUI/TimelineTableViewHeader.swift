//
//  TimleineTableViewHeader.swift
//  StumpExample
//
//  Created by Leone Parise Vieira da Silva on 06/05/17.
//  Copyright © 2017 com.leoneparise. All rights reserved.
//

import UIKit

class TimelineTableViewHeader: UIVisualEffectView {
    @IBOutlet weak var bulletView:TimelineBulletView!
    @IBOutlet weak var titleLabel:UILabel!
    
    var dateFormatter:DateFormatter = {
        let df = DateFormatter()
        df.doesRelativeDateFormatting = true
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }()
    
    static func fromNib() -> TimelineTableViewHeader {
        let bundle = Bundle(for: TimelineTableViewHeader.self)
        let nib = UINib(nibName: "TimelineTableViewHeader", bundle: bundle)
        return nib.instantiate(withOwner: nil, options: nil).first as! TimelineTableViewHeader
    }
    
    var date:Date? {
        didSet { titleLabel.text = date != nil ? dateFormatter.string(from: date!) : "" }
    }
    
    var title:String? {
        didSet { titleLabel.text = title }
    }
    
    var isFirst:Bool = false {
        didSet { bulletView.isFirst = isFirst }
    }
}
