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
    @IBOutlet var noDataPlaceholderView: UIView!
    
    
    // MARK: - Properties
    // -------------------------------------------------
    
    let cellClassName = String(describing: PhotoItemCollectionViewCell.self)
    var itemsNumberToPresent: Int = 0 {
        didSet {
            collectionView.backgroundView = (itemsNumberToPresent == 0) ? noDataPlaceholderView : nil
        }
    }

    
    // MARK: - Init Methods
    // -------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: cellClassName, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellClassName)
        
        itemsNumberToPresent = UserDefaultsManager.shared.presentedItems
    }

    
    // MARK: - Button Actions
    // -------------------------------------------------
    
    @IBAction func getPhotoButtonAction() {
        itemsNumberToPresent += 1
        UserDefaultsManager.shared.presentedItems = itemsNumberToPresent
        let indexPath = IndexPath(item: itemsNumberToPresent-1, section: 0)
        collectionView.insertItems(at: [indexPath])
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    @IBAction func clearButtonAction() {
        UserDefaultsManager.shared.clear()
        itemsNumberToPresent = 0
        collectionView.reloadData()
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
            cell.update(withData: dataToShow)
            ImageManager.getImage(withUrl: dataToShow.thumbnailUrl) { image in
                if cell.thumbnailUrl == dataToShow.thumbnailUrl {
                    cell.photoImageView.image = image
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
}
