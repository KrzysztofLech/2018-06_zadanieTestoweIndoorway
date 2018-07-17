//
//  DetailsViewController.swift
//  Indoorway
//
//  Created by Krzysztof Lech on 16.07.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    var itemImage: UIImage?
    var itemTitle: String?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicator.isHidden = true
        
        if let image = itemImage, let text = itemTitle {
            photoImageView.image = image
            titleLabel.text = text
        }
    }
    
    @IBAction func tapGestureAction(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
