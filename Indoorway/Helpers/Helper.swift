//
//  Helper.swift
//  Indoorway
//
//  Created by Krzysztof Lech on 18.06.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import UIKit

func alertWithOneButton(title: String?, message: String?, buttonTitle: String, buttonStyle: UIAlertActionStyle, controller: UIViewController, completion: @escaping (UIAlertAction)->()) {
    let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let buttonOneAction = UIAlertAction(title: buttonTitle, style: buttonStyle, handler: completion)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
    ac.addAction(buttonOneAction)
    ac.addAction(cancelAction)
    controller.present(ac, animated: true)
}
