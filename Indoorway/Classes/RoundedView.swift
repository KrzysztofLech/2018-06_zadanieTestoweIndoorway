//
//  RoundedView.swift
//  Indoorway
//
//  Created by Krzysztof Lech on 13.06.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import UIKit

@IBDesignable class RoundedView: UIView {
    
    var maskedCorners = CACornerMask()

    @IBInspectable var cornerRadius: CGFloat = 10
    
    @IBInspectable var topLeft:     Bool = false {
        didSet {
            if topLeft { maskedCorners.insert(.layerMinXMinYCorner) }
        }
    }
    @IBInspectable var topRight:    Bool = false {
        didSet {
            if topRight { maskedCorners.insert(.layerMaxXMinYCorner) }
        }
    }
    @IBInspectable var bottomLeft:  Bool = false {
        didSet {
            if bottomLeft { maskedCorners.insert(.layerMinXMaxYCorner) }
        }
    }
    @IBInspectable var bottomRight: Bool = false {
        didSet {
            if bottomRight { maskedCorners.insert(.layerMaxXMaxYCorner) }
        }
    }

    
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
        layer.maskedCorners = maskedCorners
    }
}
