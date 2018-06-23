//
//  Animations.swift
//  Indoorway
//
//  Created by Krzysztof Lech on 23.06.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import UIKit

struct Animations {
    
    static func initialShowCell(_ cell: UICollectionViewCell, withIndex index: Int) {
        UIView.animate(withDuration: 0.4, delay: 0.2 * Double(index), options: [], animations: {
            cell.alpha = 1.0
            cell.transform = CGAffineTransform.identity
        })
    }
    
    static func willDisplayShowCell(_ cell: UICollectionViewCell) {
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.3, animations: {
            cell.transform = CGAffineTransform.identity
        })
    }

    static func hideAndShowCell(_ cell: UICollectionViewCell) {
        cell.alpha = 0.0
        cell.transform = CGAffineTransform(scaleX: 0, y: 0)

        UIView.animate(withDuration: 2.4, delay: 0, options: [], animations: {
            cell.alpha = 1.0
            cell.transform = CGAffineTransform.identity
        })
    }
}
