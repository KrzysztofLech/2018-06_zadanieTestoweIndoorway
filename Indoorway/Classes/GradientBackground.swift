//
//  GradientBackground.swift
//  Indoorway
//
//  Created by Krzysztof Lech on 20.06.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import UIKit

class GradientBackground: UIView {
    
    let startColor = UIColor.white.cgColor
    let endColor   = UIColor(named: "Light Blue")?.cgColor
    
    override func draw(_: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        let colors = [startColor, endColor] as CFArray
        let colorLocations: [CGFloat] = [0.8, 1.0]
        
        if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                     colors: colors,
                                     locations: colorLocations) {
            
            let startPount = CGPoint.zero
            let endPoint = CGPoint(x: 0, y: bounds.height)
            
            context?.drawLinearGradient(gradient,
                                        start: startPount,
                                        end: endPoint,
                                        options: [])
        }
    }
}
