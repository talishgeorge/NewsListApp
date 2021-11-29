//
//  NearestAirPortCell.swift
//  Airports
//
//  Created by Talish George on 6/9/19.
//  Copyright © 2019 Airports. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Activity Indicator Type
public enum ActivityIndicatorStyles {
    case defaultSpinner
    case spinningFadeCircle
    case spinningCircle
    case spinningHalfCircles
}

class ActivityIndicatorStyle: NSObject {
    
    override init() {}
    
    /**
     Create Activity-Indicator based on provided style
     
     - parameter layer : Spinner containerview layer
     - parameter size  : Size of spinner
     - parameter color : Color of spinner, default is "lightGray"
     - parameter style : Spinner style specified by user, default style is "defaultSpinner"
     */
    func createSpinner(in layer: CALayer, size: CGSize, color: UIColor, style: ActivityIndicatorStyles) {
        switch style {
        case .defaultSpinner:
            self.createCircularLineFadingActivityIndicator(in: layer, size: size, color: color)
            
        case .spinningFadeCircle:
            self.createCircularSpinningBallWithFadingActivityIndicator(in: layer, size: size, color: color)
            
        case .spinningCircle:
            self.createCircularSpinninBallActivityIndicator(in: layer, size: size, color: color)
            
        case .spinningHalfCircles:
            self.createTwoHalfCircleSpinningActivityIndicator(in: layer, size: size, color: color)
        }
    }
    
    // MARK: - Create Spinner
    func createCircularLineFadingActivityIndicator(in layer: CALayer, size: CGSize, color: UIColor) {
        let lineSpacing: CGFloat = 1
        let lineSize = CGSize(width: (size.width - 20 * lineSpacing) / 5, height: (size.height - 6 * lineSpacing) / 3)
        let xPos = (layer.bounds.size.width - size.width) / 2
        let yPos = (layer.bounds.size.height - size.height) / 2
        let duration: CFTimeInterval = 0.5
        let beginTime = CACurrentMediaTime()
        let beginTimes: [CFTimeInterval] = [0.12, 0.24, 0.36, 0.48, 0.6, 0.72, 0.84, 0.96, 0.108, 0.120]
        let timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        // Animation
        let animation = CAKeyframeAnimation(keyPath: "opacity")
        animation.keyTimes = [0, 0.5, 1]
        animation.timingFunctions = [timingFunction, timingFunction]
        animation.values = [1, 0.3, 1]
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        
        // Draw lines
        for iDx in 0 ..< 10 {
            let line = lineAt(angle: CGFloat(Double.pi / 5 * Double(iDx)),
                              size: lineSize,
                              origin: CGPoint(x: xPos, y: yPos),
                              containerSize: size,
                              color: color)
            
            animation.beginTime = beginTime + beginTimes[iDx]
            line.add(animation, forKey: "animation")
            layer.addSublayer(line)
        }
    }
    
    func lineAt(angle: CGFloat, size: CGSize, origin: CGPoint, containerSize: CGSize, color: UIColor) -> CALayer {
        let radius = containerSize.width / 2 - max(size.width, size.height) / 2
        let lineContainerSize = CGSize(width: max(size.width, size.height), height: max(size.width, size.height))
        let lineContainer = CALayer()
        let lineContainerFrame = CGRect(
            x: origin.x + radius * (cos(angle) + 1),
            y: origin.y + radius * (sin(angle) + 1),
            width: lineContainerSize.width,
            height: lineContainerSize.height
        )
        let line = circularLineFadingActivityIndicatorlayerWith(size: size, color: color)
        let lineFrame = CGRect(
            x: (lineContainerSize.width - size.width) / 2,
            y: (lineContainerSize.height - size.height) / 2,
            width: size.width,
            height: size.height
        )
        
        lineContainer.frame = lineContainerFrame
        line.frame = lineFrame
        lineContainer.addSublayer(line)
        lineContainer.sublayerTransform = CATransform3DMakeRotation(CGFloat(Double.pi / 2) + angle, 0, 0, 1)
        
        return lineContainer
    }
    
    func circularLineFadingActivityIndicatorlayerWith(size: CGSize, color: UIColor) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        var path: UIBezierPath = UIBezierPath()
        
        path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0,
                                                width: size.width, height: size.height), cornerRadius: size.width / 2)
        layer.fillColor = color.cgColor
        
        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        return layer
    }
    
    func createCircularSpinningBallWithFadingActivityIndicator(in layer: CALayer, size: CGSize, color: UIColor) {
        let circleSpacing: CGFloat = -2
        let circleSize = (size.width - 4 * circleSpacing) / 5
        let xPos = (layer.bounds.size.width - size.width) / 2
        let yPos = (layer.bounds.size.height - size.height) / 2
        let duration: CFTimeInterval = 1
        let beginTime = CACurrentMediaTime()
        let beginTimes: [CFTimeInterval] = [0, 0.12, 0.24, 0.36, 0.48, 0.6, 0.72, 0.84]
        
        // Scale animation
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        scaleAnimation.keyTimes = [0, 0.5, 1]
        scaleAnimation.values = [1, 0.4, 1]
        scaleAnimation.duration = duration
        
        // Opacity animation
        let opacityAnimaton = CAKeyframeAnimation(keyPath: "opacity")
        
        opacityAnimaton.keyTimes = [0, 0.5, 1]
        opacityAnimaton.values = [1, 0.3, 1]
        opacityAnimaton.duration = duration
        
        // Animation
        let animation = CAAnimationGroup()
        
        animation.animations = [scaleAnimation, opacityAnimaton]
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        
        // Draw circles
        for iDx in 0 ..< 8 {
            let circle = circleAt(angle: CGFloat(Double.pi / 4) * CGFloat(iDx),
                                  size: circleSize,
                                  origin: CGPoint(x: xPos, y: yPos),
                                  containerSize: size,
                                  color: color)
            
            animation.beginTime = beginTime + beginTimes[iDx]
            circle.add(animation, forKey: "animation")
            layer.addSublayer(circle)
        }
    }
    
    func circleAt(angle: CGFloat, size: CGFloat, origin: CGPoint, containerSize: CGSize, color: UIColor) -> CALayer {
        let radius = containerSize.width / 2 - size / 2
        let circle = spinningBallWithFadingActivityIndicatorlayerWith(size: CGSize(width: size, height: size),
                                                                      color: color)
        let frame = CGRect(
            x: origin.x + radius * (cos(angle) + 1),
            y: origin.y + radius * (sin(angle) + 1),
            width: size,
            height: size
        )
        
        circle.frame = frame
        return circle
    }
    
    func spinningBallWithFadingActivityIndicatorlayerWith(size: CGSize, color: UIColor) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()
        
        path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                    radius: size.width / 2,
                    startAngle: 0,
                    endAngle: CGFloat(2 * Double.pi),
                    clockwise: false)
        layer.fillColor = color.cgColor
        
        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        return layer
    }
    
    func createCircularSpinninBallActivityIndicator(in layer: CALayer, size: CGSize, color: UIColor) {
        let circleSize = size.width / 4
        
        // Draw circles
        for iDx in 0 ..< 5 {
            let factor = Float(iDx) * 1 / 5
            let circle = circularSpinningBallActivityIndicatorlayerWith(size: CGSize(width: circleSize,
                                                                                     height: circleSize), color: color)
            let animation = rotateAnimation(factor, xPos: layer.bounds.size.width / 2,
                                            yPos: layer.bounds.size.height / 2,
                                            size: CGSize(width: size.width - circleSize,
                                                         height: size.height - circleSize))
            circle.frame = CGRect(x: 0, y: 0, width: circleSize, height: circleSize)
            circle.add(animation, forKey: "animation")
            layer.addSublayer(circle)
        }
    }
    
    func rotateAnimation(_ rate: Float, xPos: CGFloat, yPos: CGFloat, size: CGSize) -> CAAnimationGroup {
        let duration: CFTimeInterval = 1.2
        let fromScale = 1 - rate
        let toScale = 0.2 + rate
        let timeFunc = CAMediaTimingFunction(controlPoints: 0.5, 0.15 + rate, 0.25, 1)
        
        // Scale animation
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = duration
        scaleAnimation.repeatCount = HUGE
        scaleAnimation.fromValue = fromScale
        scaleAnimation.toValue = toScale
        
        // Position animation
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        positionAnimation.duration = duration
        positionAnimation.repeatCount = HUGE
        positionAnimation.path = UIBezierPath(arcCenter: CGPoint(x: xPos, y: yPos),
                                              radius: size.width / 2, startAngle: CGFloat(3 * Double.pi * 0.5),
                                              endAngle: CGFloat(3 * Double.pi * 0.5 + 2 * Double.pi),
                                              clockwise: true).cgPath
        
        // Aniamtion
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnimation, positionAnimation]
        animation.timingFunction = timeFunc
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        
        return animation
    }
    
    func circularSpinningBallActivityIndicatorlayerWith(size: CGSize, color: UIColor) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()
        
        path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                    radius: size.width / 2,
                    startAngle: 0,
                    endAngle: CGFloat(2 * Double.pi),
                    clockwise: false)
        layer.fillColor = color.cgColor
        
        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        return layer
    }
    
    func createTwoHalfCircleSpinningActivityIndicator(in layer: CALayer, size: CGSize, color: UIColor) {
        let bigCircleSize: CGFloat = size.width
        let smallCircleSize: CGFloat = size.width / 2
        let longDuration: CFTimeInterval = 0.8
        let timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        outerCircleOf(duration: longDuration,
                      timingFunction: timingFunction,
                      layer: layer,
                      size: bigCircleSize,
                      color: color, reverse: false)
        innerCircleOf(duration: longDuration,
                      timingFunction: timingFunction,
                      layer: layer,
                      size: smallCircleSize,
                      color: color, reverse: true)
    }
}
