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
    
    @IBOutlet weak var collectionContainerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionMaskView: UIView!
    
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
    fileprivate var cellsQuantityInRow: CGFloat = 2
    fileprivate let sectionInset: CGFloat = 20
    
    fileprivate var selectedCell: PhotoItemCollectionViewCell?
    
    private var isShowingFirstTime = true
    
    fileprivate let transition = PopTransition()

    
    // MARK: - Init Methods
    // -------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: cellClassName, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellClassName)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setupView),
                                               name: NSNotification.Name.UIDeviceOrientationDidChange,
                                               object: nil)
        itemsNumberToPresent = UserDefaultsManager.shared.presentedItems
        setCellsQuantityInRow()
        
        transition.dismissCompletion = {
            self.selectedCell?.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isShowingFirstTime {
            isShowingFirstTime = false
            showData()
        }
        ReachabilityManager.shared.startMonitoring()
    }

    
    // MARK: - Device Orientation Handloing Methods
    // -------------------------------------------------
    
    @objc private func setupView() {
        setCellsQuantityInRow()
        refreshView()
    }
    
    private func setCellsQuantityInRow() {
        cellsQuantityInRow = (UIApplication.shared.statusBarOrientation == .portrait) ? 2 : 4
    }
    
    private func refreshView() {
        guard itemsNumberToPresent > 0 else { return }
        
        let indexPath = IndexPath(item: itemsNumberToPresent - 1, section: 0)
        collectionView.reloadData()
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }

    
    // MARK: - Navigation Methods
    // -------------------------------------------------

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailsViewController, let itemIndex = sender as? Int {
            let dataToShow = DataManager.shared.data[itemIndex]
            vc.itemTitle = dataToShow.title
            vc.itemImage = selectedCell?.photoImageView.image
            vc.transitioningDelegate = self
        }
    }
    
    // MARK: - Button Actions
    // -------------------------------------------------
    
    @IBAction func getPhotoButtonAction() {
        guard ReachabilityManager.shared.isReachable() else {
            alertWithOneButton(title: "No Internet!",
                               message: "Try later",
                               buttonTitle: "OK", buttonStyle: .default) {_ in}
            return
        }

        itemsNumberToPresent += 1
        UserDefaultsManager.shared.presentedItems = itemsNumberToPresent
        let indexPath = IndexPath(item: itemsNumberToPresent-1, section: 0)
        collectionView.insertItems(at: [indexPath])
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    @IBAction func clearButtonAction() {
        alertWithOneButtonAndCancel(title: "Delete all items?",
                                    message: "Are you sure?",
                                    buttonTitle: "Delete",
                                    buttonStyle: .destructive) { [weak self] (_) in
            UserDefaultsManager.shared.clear()
            self?.itemsNumberToPresent = 0
            self?.collectionView.reloadData()
        }
    }
    
    
    // MARK: - UI Methods
    // -------------------------------------------------
    
    private func showData() {
        let visibleCells = collectionView.visibleCells
        let visibleCellsNumber = visibleCells.count
        
        visibleCells.forEach { cell in
            cell.alpha = 0.0
            cell.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
        
        collectionMaskView.isHidden = true

        for index in 0 ..< visibleCellsNumber {
            let indexPath = IndexPath(item: index, section: 0)
            if let cell = collectionView.cellForItem(at: indexPath) {
                Animations.initialShowCell(cell, withIndex: index)
            }
        }
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        Animations.willDisplayShowCell(cell)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = collectionView.cellForItem(at: indexPath) as? PhotoItemCollectionViewCell
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.performSegue(withIdentifier: "DetailsVC", sender: indexPath.item)
        }
    }
}


// MARK: - CollectionView Delegate Flow Layout Methods
// ---------------------------------------------------

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: sectionInset,left: sectionInset, bottom: 0, right: sectionInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize()
    }
    
    private func cellSize() -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        let insetsSpace = (cellsQuantityInRow + 1) * sectionInset
        let spaceForCells = collectionViewWidth - insetsSpace
        let cellWidth = spaceForCells / cellsQuantityInRow
        let cellHeight = cellWidth + 50 + sectionInset
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension MainViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let selectedCellFrame = selectedCell!.superview!.convert(selectedCell!.frame, to: nil)
        
        transition.originFrame = selectedCellFrame
        print(selectedCellFrame)
        
        transition.presenting = true
        selectedCell?.isHidden = true
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}
