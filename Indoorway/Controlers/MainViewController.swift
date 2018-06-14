//
//  MainViewController.swift
//  Indoorway
//
//  Created by Krzysztof Lech on 13.06.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - Outlets
    // -------------------------------------------------
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var rightButton: UIButton!
    
    
    // MARK: - Properties
    // -------------------------------------------------
    
    let cellClassName = String(describing: PhotoItemCollectionViewCell.self)
    var itemsNumberToPresent: Int = 1000 {
        didSet {
            DataManager.shared.presentedItemsCounter += 1
        }
    }

    
    // MARK: - Init Methods
    // -------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: cellClassName, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellClassName)
    }

    
    // MARK: - Button Actions
    // -------------------------------------------------
    
    @IBAction func getPhotoButtonAction() {
        itemsNumberToPresent += 1
        let indexPath = IndexPath(item: itemsNumberToPresent-1, section: 0)
        collectionView.insertItems(at: [indexPath])
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    @IBAction func clearButtonAction() {
    }
}

// MARK: - CollectionView Methods
// -------------------------------------------------

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard itemsNumberToPresent <= DataManager.shared.data.count else { return 0 }
        return itemsNumberToPresent
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellClassName, for: indexPath) as? PhotoItemCollectionViewCell {
            let dataToShow = DataManager.shared.data[indexPath.item]
            cell.titleLabel.text = dataToShow.title
            ImageManager.downloadImage(withUrl: dataToShow.thumbnailUrl) { image in
                cell.photoImageView.image = image
            }
            return cell
        }
        return UICollectionViewCell()
    }
}
