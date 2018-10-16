//
//  PhotoItem.swift
//  Indoorway
//
//  Created by Krzysztof Lech on 13.06.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import Foundation

struct PhotoItem: Codable {
    
    let id:           Int
    let title:        String
    let url:          String
    let thumbnailUrl: String
}
