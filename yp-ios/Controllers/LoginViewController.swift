//
//  LoginViewController.swift
//  Blogy
//
//  Created by admin on 22/09/2017.
//  Copyright © 2017 malekmouzayen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    let defaults = UserDefaults.standard

    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = false
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        
        if userEmail == "" {
            showAlertBox(title: "Missing Fields", message: "Email field is empty")
            return
        } else if !isValidEmail(testStr: userEmail!){
            showAlertBox(title: "Wrong email", message: "The email addresse is not valied")
            return
        } else if userPassword == "" {
            showAlertBox(title: "Missing Fields", message: "Password field is empty")
            return
        }
        handelLogin(userEmail: userEmail!, userPassword: userPassword!)
    }

    func handelLogin(userEmail: String, userPassword: String) {
        
        let activiteIndecator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activiteIndecator.center = view.center
        activiteIndecator.hidesWhenStopped = false
        view.addSubview(activiteIndecator)
        activiteIndecator.startAnimating()
        Communication.sharedInstance.userLogin(email: userEmail, password: userPassword) { (authenticated, id) in
            if authenticated {
                if let userId = id {
                    let userInfo = ["email": userEmail, "password": userPassword, "userId": userId] as [String : Any]
                    self.defaults.set(userInfo, forKey: "userInfo")
                }
                activiteIndecator.stopAnimating()
                if let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBar") as? UITabBarController {
                    self.present(tabViewController, animated: true, completion: nil)
                }
            } else {
                activiteIndecator.stopAnimating()
                self.showAlertBox(title: "Error", message: "Please check your info and make sure to connect to internet")
            }
        }
    }
}
