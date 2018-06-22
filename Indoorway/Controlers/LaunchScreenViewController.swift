//
//  LaunchScreenViewController.swift
//  Indoorway
//
//  Created by Krzysztof Lech on 13.06.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    @IBOutlet weak var textContainerView: UIView!
    @IBOutlet weak var activityIndicatorView: UIView!
    
    let circularTransition = CircularTransition()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let toViewController = segue.destination
        toViewController.transitioningDelegate = circularTransition
    }
    
    private func getData() {
        if ReachabilityManager.shared.isReachable() {
            DataManager.shared.getPhotosData {
                self.activityIndicatorView.isHidden = true
                self.hideSplashScreen()
            }
        } else {
            alertWithOneButton(title: "No Internet!",
                               message: nil,
                               buttonTitle: "Try again", buttonStyle: .default) { _ in
                                self.getData()
            }
        }
    }
    
    private func hideSplashScreen() {
        UIView.animate(withDuration: 1, animations: {
            self.textContainerView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { _ in
            self.performSegue(withIdentifier: "MainVC", sender: nil)
        }
    }
}
