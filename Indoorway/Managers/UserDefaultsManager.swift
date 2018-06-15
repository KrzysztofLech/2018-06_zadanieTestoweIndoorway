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
    private init() {}
    
    func write(object: Any, forKey key: String) {
        UserDefaults.standard.set(object, forKey: key)
    }
    
    func getObject(forKey key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    func removeObject(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
