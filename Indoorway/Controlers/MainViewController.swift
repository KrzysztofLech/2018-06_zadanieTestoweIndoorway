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
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var rightButton: UIButton!
    @IBOutlet private var noDataPlaceholderView: UIView!
    
    
    // MARK: - Properties
    // -------------------------------------------------
    
    private let cellClassName = String(describing: PhotoItemCollectionViewCell.self)
    private var itemsNumberToPresent: Int = 0 {
        didSet {
            collectionView.backgroundView = (itemsNumberToPresent == 0) ? noDataPlaceholderView : nil
        }
    }
    // Coolection View properties
    fileprivate let cellsQuintityInRow: CGFloat = 2
    fileprivate let sectionInset: CGFloat = 20

    
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

// MARK: - CollectionView Delegate & DataSource Methods
// ----------------------------------------------------

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

// MARK: - CollectionView Delegate Flow Layout Methods
// ---------------------------------------------------

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: sectionInset,left: sectionInset, bottom: sectionInset, right: sectionInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize()
    }
    
    private func cellSize() -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        let insetsSpace = (cellsQuintityInRow + 1) * sectionInset
        let spaceForCells = collectionViewWidth - insetsSpace
        let cellWidth = spaceForCells / cellsQuintityInRow
        let cellHeight = cellWidth + 50
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
