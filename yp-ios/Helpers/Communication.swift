//
//  Commuincation.swift
//  yp-ios
//
//  Created by Ibrahim Zakarya on 2/6/18.
//  Copyright © 2018 Ibrahim Zakarya. All rights reserved.
//

import Foundation
import Alamofire

class Communication {
    
    static let sharedInstance = Communication()
    
    let baseURL = "http://ibrahim-yp.vapor.cloud"
//    let baseURL = "http://localhost:8080"
    let getAllPlacesURL = "/place/all"
    let getPlaceDetails = "/place/"
    let getPlaceComment = "/comment/"
    let addRating = "/rating/add"
    let search = "/place/search"
    let addFavorite = "/user/favorite/add"
    let login = "/user/login"
    let register = "/user/register"
    let createComment = "/comment/create"
    let sendMessage = "/message/send"
    
    let userDefaults = UserDefaults.standard.object(forKey: "userInfo") as? [String: Any]
    
    func getAllPlaces(callback : @escaping ([Place]) -> Void) {
        let url = URL(string: baseURL + getAllPlacesURL)
        Alamofire.request(url!, method: .post).responseJSON { response in
            
            if let err = response.error {
                print("ZZZ", err)
                let places = [Place]()
                callback(places)
                return
            }
            if let json = response.result.value as? [[String: AnyObject]] {
                var places = [Place]()
                for j in json {
                    guard let id = j["id"] as? Int, let name = j["name"] as? String, let longitude = j["longitude"] as? Double, let latitude = j["latitude"] as? Double, let address = j["address"] as? String, let rating = j["rating"] as? Double, let phone = j["phone"] as? String else { return }
                    let logo = j["logo"] as? String
                    let mobile = j["mobile"] as? String
                    let place = Place(id: id, name: name, longitude: longitude, latitude: latitude, phone: phone, rating: rating, classification: "", mobile: mobile, address: address, logo: logo, details: nil, website: nil, closeTime: nil, openTime: nil)
                    places.append(place)
                }
                callback(places)
            }
        }
    }
    
    func getPlaceDetails(placeId: Int, callback : @escaping (Place) -> Void) {
        let url = URL(string: baseURL + getPlaceDetails + String(placeId))
        
        Alamofire.request(url!, method: .get).responseJSON { response in
            
            if let j = response.result.value as? [String: AnyObject] {
                guard let id = j["id"] as? Int, let name = j["name"] as? String, let address = j["address"] as? String, let rating = j["rate"] as? Double, let classification = j["classification"] as? String, let phone = j["phone"] as? String, let longitude = j["longitude"] as? Double, let latitude = j["latitude"] as? Double else { return }
                let logo = j["logo"] as? String
                let mobile = j["mobile"] as? String
                let details = j["details"] as? String
                let openTime = j["open_time"] as? String
                let closeTime = j["close_time"] as? String
                let website = j["website"] as? String
                var comments = [Comment]()
                if let jsonComments = j["comments"] as? [[String: AnyObject]] {
                    for comment in jsonComments {
                        guard let username = comment["user_fullname"] as? String, let text = comment["text"] as? String else {return}
                        guard let date = comment["created"] as? String else {return}
                        let convertedDate = self.convertDateTo(string: date)
                        let comment = Comment(text: text, date: convertedDate, userFullname: username)
                        comments.append(comment)
                    }
                }
                let place = Place(id: id, name: name, longitude: longitude, latitude: latitude, phone: phone, rating: rating, classification: classification, mobile: mobile, address: address, logo: logo, details: details, website: website, closeTime: closeTime, openTime: openTime)
                place.comments = comments
                callback(place)
            }
        }
    }
    
    func addRating(placeId: Int, userId: Int, rating: Double) {
        
        guard let user = userDefaults?["email"] as? String, let password = userDefaults?["password"] as? String else { return}
        
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        let url = URL(string: baseURL + addRating)
        let params = ["placeId": placeId, "rating": rating, "userId": userId] as [String : Any]
        Alamofire.request(url!, method: .post, parameters: params, headers: headers).response { response in
        }
    }
    
    func addComment(userId: Int, placeId: Int, text: String) {
        guard let user = userDefaults?["email"] as? String, let password = userDefaults?["password"] as? String else { return}
        
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        let url = URL(string: baseURL + createComment)
        let params = ["placeId": placeId, "text": text, "userId": userId] as [String : Any]
        Alamofire.request(url!, method: .post, parameters: params, headers: headers).response { response in
        }
    }
    
    func userLogin(email: String, password: String, callback : @escaping (Bool, Int?) -> Void) {
        let url = URL(string: baseURL + login)
        let params = ["email": email, "password": password]
        
        Alamofire.request(url!, method: .post, parameters: params).responseJSON { response in
            if response.response?.statusCode == 200 {
                if let data = response.result.value as? [String: AnyObject] {
                    let userId = data["id"] as? Int
                    callback(true, userId)
                } else {
                    callback(false, nil)
                }
            } else {
                callback(false, nil)
            }
        }
    }
    
    func userRegister(email: String, fullname: String, password: String, callback: @escaping(Bool, Int?) -> Void) {
        let url = URL(string: baseURL + register)
        let params = ["email": email, "fullname": fullname, "password": password, "username": email]
        Alamofire.request(url!, method: .post, parameters: params).responseJSON { response in
            if response.response?.statusCode == 200 {
                if let data = response.result.value as? [String: AnyObject] {
                    let userId = data["id"] as? Int
                    callback(true, userId)
                } else {
                    callback(false, nil)
                }
                
            } else {
                callback(false, nil)
            }
        }
    }
    
    func addToFavorite(userId: Int, placeId: Int, callback : @escaping (Bool, Bool) -> Void) {
        let url = URL(string: baseURL + addFavorite)
        let params = ["placeId": placeId, "userId": userId] as [String : Any]
        Alamofire.request(url!, method: .post, parameters: params).response { response in
            if let data = response.data {
                let json = String(data: data, encoding: String.Encoding.utf8)
                if json == "Already exist" {
                    callback(true, true)
                } else if response.response?.statusCode == 200 {
                    callback(true, false)
                } else {
                    callback(false, false)
                }
            }
            
        }
    }
    
    func removeFromFavorite(userId: Int, placeId: Int, callback : @escaping (Bool) -> Void) {
        let url = URL(string: baseURL + "/user/favorite/delete")
        let params = ["placeId": placeId, "userId": userId] as [String : Any]
        Alamofire.request(url!, method: .post, parameters: params).response { response in
            if response.response?.statusCode == 200 {
                callback(true)
            } else {
                callback(false)
            }
        }
    }
    
    func getUserFavorite(userId: Int, callback: @escaping ([Place]) -> Void) {
        let url = URL(string: baseURL + "/user/\(userId)/favorites")
        Alamofire.request(url!, method: .post).responseJSON { response in
            //            print(response.result.value)
            if let json = response.result.value as? [String: AnyObject] {
                var places = [Place]()
                if let favs = json["favorites"] as? [[String: AnyObject]] {
                    for fav in favs {
                        if let j = fav["place"] as? [String: AnyObject] {
                            guard let id = j["id"] as? Int, let name = j["name"] as? String, let longitude = j["longitude"] as? Double, let latitude = j["latitude"] as? Double, let address = j["address"] as? String, let rating = j["rating"] as? Double, let phone = j["phone"] as? String else { return }
                            let logo = j["logo"] as? String
                            let mobile = j["mobile"] as? String
                            let place = Place(id: id, name: name, longitude: longitude, latitude: latitude, phone: phone, rating: rating, classification: "", mobile: mobile, address: address, logo: logo, details: nil, website: nil, closeTime: nil, openTime: nil)
                            places.append(place)
                        }
                    }
                    callback(places)
                }
            }
        }
    }
    
    func serach(for text: String, callback : @escaping ([Place]) -> Void) {
        let url = URL(string: baseURL + search)
        let params = ["query": text]
        Alamofire.request(url!, method: .post, parameters: params).responseJSON { response in
            
            if let err = response.error {
                print(err)
                return
            }
            if let json = response.result.value as? [[String: AnyObject]] {
                var places = [Place]()
                for j in json {
                    guard let id = j["id"] as? Int, let name = j["name"] as? String, let longitude = j["longitude"] as? Double, let latitude = j["latitude"] as? Double, let address = j["address"] as? String, let rating = j["rating"] as? Double, let phone = j["phone"] as? String else { return }
                    let logo = j["logo"] as? String
                    let mobile = j["mobile"] as? String
                    let place = Place(id: id, name: name, longitude: longitude, latitude: latitude, phone: phone, rating: rating, classification: "", mobile: mobile, address: address, logo: logo, details: nil, website: nil, closeTime: nil, openTime: nil)
                    places.append(place)
                }
                callback(places)
            }
        }
    }
    
    func sendMessage(message: String, email: String, subject: String, userId: Int?, callback : @escaping (Bool) -> Void) {
        let url = URL(string: baseURL + sendMessage)
        let params: [String : Any]
        if let userID = userId {
            params = ["message": message, "user_id": userID, "subject": subject, "email": email]
        } else  {
            params = ["message": message, "subject": subject, "email": email]
        }
        Alamofire.request(url!, method: .post, parameters: params).responseJSON { response in
            if response.response?.statusCode == 200 {
                callback(true)
            } else {
                callback(false)
            }
        }
    }
    
    func convertDateTo(string: String) -> String{
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let convertedDate = formater.date(from: string)
        
        formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formater.string(from: convertedDate!)
        return date
    }
}
