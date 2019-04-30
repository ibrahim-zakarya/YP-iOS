//
//  Comment.swift
//  yp-ios
//
//  Created by Ibrahim Zakarya on 2/5/18.
//  Copyright © 2018 Ibrahim Zakarya. All rights reserved.
//

import Foundation

class Comment: NSObject {
    
    var text: String
    var date: String
    var userFullname: String
//    var placeId: Int
    
    init(text: String, date: String, userFullname: String/*, placeId: Int*/) {
        self.text = text
        self.date = date
        self.userFullname = userFullname
//        self.placeId = placeId
    }
}
