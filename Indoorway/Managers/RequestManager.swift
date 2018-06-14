//
//  RequestManager.swift
//  Indoorway
//
//  Created by Krzysztof Lech on 14.06.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import Foundation

struct RequestManager {
    
    private static let baseUrl = "https://jsonplaceholder.typicode.com/photos/"
    
    static func getPhotosData(closure: @escaping (_ data: Data) -> ()) {
        guard let endPointUrl = URL(string: baseUrl) else {
            print("Error: Cannot create URL")
            return
        }
        
        let urlRequest = URLRequest(url: endPointUrl)
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                print("error calling GET")
                print(error!)
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            closure(responseData)
        }
        task.resume()
    }
}
