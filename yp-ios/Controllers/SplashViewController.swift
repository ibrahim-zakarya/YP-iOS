//
//  SplashViewController.swift
//  Blogy
//
//  Created by admin on 22/09/2017.
//  Copyright © 2017 malekmouzayen. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.navigationBar.isHidden = true
        checkUserInfo()

    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true

    }
    
    func checkUserInfo() {
        if let _ = UserDefaults.standard.object(forKey: "userInfo") as? [String: Any] {
            if let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBar") as? UITabBarController {
                self.present(tabViewController, animated: true, completion: nil)
            }
        }
    }

    @IBAction func exploreTheApp(_ sender: Any) {
        if let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBar") as? UITabBarController {
            self.present(tabViewController, animated: true, completion: nil)
        }
    }
    

}
