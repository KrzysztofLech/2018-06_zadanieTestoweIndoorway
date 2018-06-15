//
//  DataManager.swift
//  Indoorway
//
//  Created by Krzysztof Lech on 14.06.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import Foundation

class DataManager {

    static let shared = DataManager()

    var data: [PhotoItem] = {
        var array: [PhotoItem] = []
        array.reserveCapacity(5000)
        return array
    }()

    private init() { }
    
    func getPhotosData(completion: @escaping (()->()) ) {
        removeAllData()

        print("Download data was started!")
        RequestManager.getPhotosData { (jsonData) in
            let decoder = JSONDecoder()
            do {
                self.data = try decoder.decode([PhotoItem].self, from: jsonData)
                print("Downloading acomplished!")
                DispatchQueue.main.async {
                    completion()
                }

            } catch {
                print("Decode error: ", error)
            }
        }
    }
    
    func removeAllData() {
        data.removeAll(keepingCapacity: true)
    }
}
