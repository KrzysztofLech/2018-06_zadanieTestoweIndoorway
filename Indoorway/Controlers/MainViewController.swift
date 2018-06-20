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
    
    @IBOutlet weak var topView: RoundedView!
    @IBOutlet weak var bottomView: RoundedView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet private weak var rightButton: UIButton!
    @IBOutlet private var noDataPlaceholderView: UIView!
    @IBOutlet private weak var headerTitleLabel: UILabel!
    
    
    // MARK: - Properties
    // -------------------------------------------------
    
    private let cellClassName = String(describing: PhotoItemCollectionViewCell.self)
    private var itemsNumberToPresent: Int = 0 {
        didSet {
            collectionView.backgroundView = (itemsNumberToPresent == 0) ? noDataPlaceholderView : nil
            setupRightButton()
            setupHeaderTitle()
        }
    }
    // Coolection View properties
    fileprivate var cellsQuintityInRow: CGFloat = 2
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
        alertWithOneButton(title: "Delete all items?", message: "Are you sure?", buttonTitle: "Delete", buttonStyle: .destructive, controller: self) { [weak self] (_) in
            UserDefaultsManager.shared.clear()
            self?.itemsNumberToPresent = 0
            self?.collectionView.reloadData()
        }
    }
    
    // MARK: - UI Methods
    // -------------------------------------------------
    
    private func setupRightButton() {
        if itemsNumberToPresent > 1 { return }

        if itemsNumberToPresent == 0 {
            UIView.transition(with: view, duration: 0.5, options: [], animations: {
                self.rightButton.isHidden = true
                self.rightButton.alpha = 0
            })
        } else {
            rightButton.alpha = 0
            rightButton.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.rightButton.alpha = 1.0
            })
        }
    }
    
    private func setupHeaderTitle() {
        var text: String
        switch itemsNumberToPresent {
        case 0:
            text = ""
        case 1:
            text = String(format: "Photo: %i/5000", itemsNumberToPresent)
        default:
            text = String(format: "Photos: %i/5000", itemsNumberToPresent)
        }
        headerTitleLabel.text = text
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
                    cell.activityIndicator.stopAnimating()
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
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize()
    }
    
    private func cellSize() -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        let insetsSpace = (cellsQuintityInRow + 1) * sectionInset
        let spaceForCells = collectionViewWidth - insetsSpace
        let cellWidth = spaceForCells / cellsQuintityInRow
        let cellHeight = cellWidth + 50 + sectionInset
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
