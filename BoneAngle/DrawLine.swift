//
//  DrawLine.swift
//  BoneAngle
//
//  Created by Mac Watrous on 12/16/15.
//  Copyright © 2015 Mac Watrous. All rights reserved.
//

import UIKit

class DrawLine: UIView {
    
    override func drawRect(rect: CGRect){
        var ex = rect.maxX
        var ey = rect.maxY
        var sx = rect.origin.x
        var sy = rect.origin.y
        
        if ey < 0 {
            print("negative height")
        }
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2.0)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [0.0, 0.0, 1.0, 1.0]
        let color = CGColorCreate(colorSpace, components)
        CGContextSetStrokeColorWithColor(context, color)
        CGContextMoveToPoint(context, sx, sy)
        CGContextAddLineToPoint(context, ex, ey)
        CGContextStrokePath(context)
        print("Adding line")
    }
    
}
