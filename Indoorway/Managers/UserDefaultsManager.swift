//
//  UserDefaultsManager.swift
//  Indoorway
//
//  Created by Krzysztof Lech on 15.06.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import Foundation

struct UserDefaultsKey {
    static let presentedItems = "presentedItems"
}

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    // MARK: - Private methods
    
    private init() {}
    
    private func write(object: Any, forKey key: String) {
        UserDefaults.standard.set(object, forKey: key)
    }
    
    private func getObject(forKey key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    private func removeObject(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    
    // MARK: - Public properties and methods
    
    var presentedItems: Int {
        get {
            if let number = getObject(forKey: UserDefaultsKey.presentedItems) as? Int {
                return number
            }
            return 0
        }
        set {
            write(object: newValue, forKey: UserDefaultsKey.presentedItems)
        }
    }
    
    func clear() {
        removeObject(forKey: UserDefaultsKey.presentedItems)
    }
}
