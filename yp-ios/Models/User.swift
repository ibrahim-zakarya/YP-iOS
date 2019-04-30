//
//  User.swift
//  yp-ios
//
//  Created by Ibrahim Zakarya on 2/5/18.
//  Copyright © 2018 Ibrahim Zakarya. All rights reserved.
//

import Foundation

class User: NSObject {
    var userId: Int
    var username: String
    var name: String
    var email: String
    var password: String
    
    init(userId: Int, username: String, name: String, email: String, password: String) {
        self.userId = userId
        self.username = username
        self.name = name
        self.email = email
        self.password = password
    }
    
    static func getUserInfo() -> User? {
        if let userDefault = UserDefaults.standard.object(forKey: "userInfo") as? [String: Any] {
            if let email = userDefault["email"] as? String, let password = userDefault["password"] as? String, let userId = userDefault["userId"] as? Int {
                let user = User(userId: userId, username: email, name: "", email: email, password: password)
                return user
            }
        }
        return nil
    }
}
