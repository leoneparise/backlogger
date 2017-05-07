//
//  TimelineView.swift
//  StumpExample
//
//  Created by Leone Parise Vieira da Silva on 06/05/17.
//  Copyright © 2017 com.leoneparise. All rights reserved.
//

import UIKit

@IBDesignable
class TimelineBulletView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.contentMode = .center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    // MARK: State
    @IBInspectable var isFirst:Bool = true {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable var showBullet:Bool = true {
        didSet { setNeedsDisplay() }
    }
    
    // Mark: Config
    @IBInspectable var lineColor:UIColor = .darkGray {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable var bulletColor:UIColor = .white {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable var bulletSize:CGSize = CGSize(width: 10, height: 10) {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable var lineWidth:CGFloat = 1.0 {
        didSet { setNeedsDisplay() }
    }
    
    // MARK: Draw
    override func draw(_ rect: CGRect) {
        let (w, h) = (rect.width, rect.height)
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        if isFirst {
            drawLine(from: CGPoint(x: w/2, y: h/2), to: CGPoint(x: w/2, y:h), context: ctx)
        } else {
            drawLine(from: CGPoint(x: w/2, y: 0), to: CGPoint(x: w/2, y:h), context: ctx)
        }
        if showBullet {
            drawCircle(center: CGPoint(x: w/2, y: h/2), size:bulletSize, context: ctx)
        }
    }
}

extension TimelineBulletView {
    func drawLine(from: CGPoint, to:CGPoint, context ctx:CGContext) {
        ctx.setStrokeColor(lineColor.cgColor)
        ctx.setLineWidth(lineWidth)
        ctx.move(to: CGPoint(x: from.x, y: from.y))
        ctx.addLine(to: CGPoint(x: to.x, y: to.y))
        ctx.strokePath()
    }
    
    func drawCircle(center:CGPoint, size:CGSize, context ctx: CGContext) {
        let rect = CGRect(x: center.x - size.width / 2,
                          y: center.y - size.height / 2,
                          width: size.width,
                          height: size.height)
        
        // Add circle
        ctx.setFillColor(bulletColor.cgColor)
        ctx.addEllipse(in: rect)
        ctx.fillPath()
        
        // Add circle border
        ctx.setStrokeColor(lineColor.cgColor)
        ctx.setLineWidth(lineWidth)
        ctx.addEllipse(in: rect)
        ctx.strokePath()
    }
}
