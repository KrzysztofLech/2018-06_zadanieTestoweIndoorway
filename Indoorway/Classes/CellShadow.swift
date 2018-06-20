//
//  CellShadow.swift
//  Indoorway
//
//  Created by Krzysztof Lech on 20.06.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import UIKit

class CellShadow: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = 4

        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 3
        layer.shadowColor = UIColor(named: "CellShadow")?.cgColor
        layer.shadowOpacity = 0.2
    }
}
