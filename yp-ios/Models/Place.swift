//
//  Place.swift
//  yp-ios
//
//  Created by Ibrahim Zakarya on 2/5/18.
//  Copyright © 2018 Ibrahim Zakarya. All rights reserved.
//

import Foundation

class Place: NSObject {
    var id: Int
    var name: String
    var longitude: Double
    var latitude: Double
    var phone: String
    var rating: Double
    var classification: String
    var mobile: String?
    var address: String?
    var logo: String?
    var details: String?
    var website: String?
    var closeTime: String?
    var openTime: String?
    var comments: [Comment]?
    
    
    init(id: Int, name: String, longitude: Double, latitude: Double, phone: String, rating: Double, classification: String, mobile: String?, address: String?, logo: String?, details: String?, website: String?, closeTime: String?, openTime: String?) {
        self.id = id
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
        self.phone = phone
        self.classification = classification
        self.rating = rating
        self.mobile = mobile
        self.address = address
        self.logo = logo
        self.details = details
        self.website = website
        self.closeTime = closeTime
        self.openTime = openTime
    }
}
