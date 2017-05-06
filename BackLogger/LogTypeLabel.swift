//
//  LogTypeLabel.swift
//  StumpExample
//
//  Created by Leone Parise Vieira da Silva on 06/05/17.
//  Copyright © 2017 com.leoneparise. All rights reserved.
//

import UIKit

fileprivate func configure(_ typeOrNil:LogType?) -> (UILabel) -> () {
    guard let type = typeOrNil else { return { _ in } }
    
    switch type {
    case .debug:
        return { label in
            label.text = "DEBUG"
            label.backgroundColor = UIColor(hex: 0x3cb371)
        }
    case .info:
        return { label in
            label.text = "INFO"
            label.backgroundColor = UIColor(hex: 0x0099cc)
        }
    case .warn:
        return { label in
            label.text = "WARN"
            label.backgroundColor = UIColor(hex: 0xff9933)
        }
    case .error:
        return { label in
            label.text = "ERROR"
            label.backgroundColor = UIColor(hex: 0xdc143c)
        }
    }
}

@IBDesignable
public class LogTypeLabel: UILabel {
    public var type:LogType? {
        didSet {
            configure(self.type)(self)
            setNeedsLayout()
        }
    }
    
    public convenience init(type:LogType) {
        self.init(frame: CGRect.zero)
        self.type = type
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 3
        self.font = UIFont.systemFont(ofSize: 8, weight: 500)
        self.textColor = .white
        self.backgroundColor = .darkGray
        self.textAlignment = .center
    }
        
    public override func prepareForInterfaceBuilder() {
        commonInit()
        self.type = .info
    }
}
