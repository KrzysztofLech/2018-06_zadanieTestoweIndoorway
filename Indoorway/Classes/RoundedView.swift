//
//  RoundedView.swift
//  Indoorway
//
//  Created by Krzysztof Lech on 13.06.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import UIKit

@IBDesignable class RoundedView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 10
    
    @IBInspectable var topLeft: Bool     = false
    @IBInspectable var topRight: Bool    = false
    @IBInspectable var bottomLeft: Bool  = false
    @IBInspectable var bottomRight: Bool = false
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setCorners()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCorners()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCorners()
    }
    
    private func setCorners() {
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius

        switch (topLeft, topRight, bottomLeft, bottomRight) {
        case (true, false, false, false): layer.maskedCorners = [.layerMinXMinYCorner]
        case (false, true, false, false): layer.maskedCorners = [.layerMaxXMinYCorner]
        case (false, false, true, false): layer.maskedCorners = [.layerMinXMaxYCorner]
        case (false, false, false, true): layer.maskedCorners = [.layerMaxXMaxYCorner]
            
        case (true, true, false, false): layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case (true, false, true, false): layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        case (true, false, false, true): layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        case (false, true, true, false): layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        case (false, true, false, true): layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        case (false, false, true, true): layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            
        case (true, true, true, false): layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        case (true, false, true, true): layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case (false, true, true, true): layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case (true, true, false, true): layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            
        case (true, true, true, true): layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case (false, false, false, false): layer.maskedCorners = []
        }
    }
}
