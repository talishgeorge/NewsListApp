//
//  ActivityInidicatorViewStyle+Animation.swift
//  Airports
//
//  Created by Talish George on 6/12/19.
//  Copyright © 2019 Airports. All rights reserved.
//

import Foundation
import UIKit

extension ActivityIndicatorStyle {
    func createAnimationIn(duration: CFTimeInterval, timingFunction: CAMediaTimingFunction,
                           reverse: Bool) -> CAAnimation {
        // Scale animation
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.keyTimes = [0, 0.5, 1]
        scaleAnimation.timingFunctions = [timingFunction, timingFunction]
        scaleAnimation.values = [1, 1, 1]
        scaleAnimation.duration = duration
        
        // Rotate animation
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        if !reverse {
            rotateAnimation.fromValue = 0.0
            rotateAnimation.toValue = CGFloat(Double.pi * 2.0)
            rotateAnimation.duration = duration
        } else {
            rotateAnimation.fromValue = CGFloat(Double.pi * 2.0)
            rotateAnimation.toValue = 0.0
            rotateAnimation.duration = duration
        }
        
        // Animation
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnimation, rotateAnimation]
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        
        return animation
    }
    
    func innerCircleOf(duration: CFTimeInterval, timingFunction: CAMediaTimingFunction,
                       layer: CALayer,
                       size: CGFloat, color: UIColor, reverse: Bool) {
        let circle = innerHalfCirclelayerWith(size: CGSize(width: size, height: size), color: color)
        let frame = CGRect(x: (layer.bounds.size.width - size) / 2,
                           y: (layer.bounds.size.height - size) / 2,
                           width: size,
                           height: size)
        let animation = createAnimationIn(duration: duration, timingFunction: timingFunction, reverse: reverse)
        
        circle.frame = frame
        circle.add(animation, forKey: "animation")
        layer.addSublayer(circle)
    }
    
    func innerHalfCirclelayerWith(size: CGSize, color: UIColor) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()
        let lineWidth: CGFloat = 2
        
        path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                    radius: size.width / 2,
                    startAngle: CGFloat(-3 * Double.pi / 4),
                    endAngle: CGFloat(-Double.pi / 4),
                    clockwise: true)
        path.move(
            to: CGPoint(x: size.width / 2 - size.width / 2 * cos(CGFloat(Double.pi / 4)),
                        y: size.height / 2 + size.height / 2 * sin(CGFloat(Double.pi / 4)))
        )
        path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                    radius: size.width / 2,
                    startAngle: CGFloat(-5 * Double.pi / 4),
                    endAngle: CGFloat(-7 * Double.pi / 4),
                    clockwise: false)
        layer.fillColor = nil
        layer.strokeColor = color.cgColor
        layer.lineWidth = lineWidth
        
        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        return layer
    }
    
    func outerCircleOf(duration: CFTimeInterval, timingFunction: CAMediaTimingFunction,
                       layer: CALayer, size: CGFloat, color: UIColor, reverse: Bool) {
        let circle = outerHalfCirclelayerWith(size: CGSize(width: size, height: size), color: color)
        let frame = CGRect(x: (layer.bounds.size.width - size) / 2,
                           y: (layer.bounds.size.height - size) / 2,
                           width: size,
                           height: size)
        let animation = createAnimationIn(duration: duration, timingFunction: timingFunction, reverse: reverse)
        
        circle.frame = frame
        circle.add(animation, forKey: "animation")
        layer.addSublayer(circle)
    }
    
    func outerHalfCirclelayerWith(size: CGSize, color: UIColor) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()
        let lineWidth: CGFloat = 2
        
        path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                    radius: size.width / 2,
                    startAngle: CGFloat(3 * Double.pi / 4),
                    endAngle: CGFloat(5 * Double.pi / 4),
                    clockwise: true)
        path.move(
            to: CGPoint(x: size.width / 2 + size.width / 2 * cos(CGFloat(Double.pi / 4)),
                        y: size.height / 2 - size.height / 2 * sin(CGFloat(Double.pi / 4)))
        )
        path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                    radius: size.width / 2,
                    startAngle: CGFloat(-Double.pi / 4),
                    endAngle: CGFloat(Double.pi / 4),
                    clockwise: true)
        layer.fillColor = nil
        layer.strokeColor = color.cgColor
        layer.lineWidth = lineWidth
        
        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        return layer
    }
}
