//
//  PhotoItemCollectionViewCell.swift
//  Indoorway
//
//  Created by Krzysztof Lech on 13.06.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import UIKit

class PhotoItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCell()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        resetCell()
    }
    
    private func resetCell() {
        photoImageView.image = nil
        titleLabel.text = "ABC"
    }
    
    func update(with imageUrl: String, title: String) {
        titleLabel.text = title
    }
}
