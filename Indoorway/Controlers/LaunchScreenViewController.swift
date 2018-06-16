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
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DataManager.shared.getPhotosData {
            self.activityIndicatorView.isHidden = true
            self.hideSplashScreen()
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
