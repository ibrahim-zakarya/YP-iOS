//
//  RegisterViewController.swift
//  Blogy
//
//  Created by admin on 23/09/2017.
//  Copyright © 2017 malekmouzayen. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    @IBOutlet weak var userFullnameTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userConfirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        let confirmPassword = userConfirmPasswordTextField.text
        let fullname = userFullnameTextField.text
        
        if userEmail == "" {
            showAlertBox(title: "Missing Fields", message: "Email field is empty")
            return
        } else if !isValidEmail(testStr: userEmail!){
            showAlertBox(title: "Wrong email", message: "The email addresse is not valied")
            return
        } else if userPassword == "" {
            showAlertBox(title: "Missing Fields", message: "Password field is empty")
            return
        } else if confirmPassword == ""  {
            showAlertBox(title: "Missing Fields", message: "Confirm password field is empty")
            return
        } else if confirmPassword != userPassword {
            showAlertBox(title: "Wrong Password", message: "Passwords do not match")
            return
        } else if fullname == "" {
            showAlertBox(title: "Missing Fields", message: "Fullname field is empty")
            return
        }
        
        handelUserRegisteration(userEmail: userEmail!, userPassword: userPassword!, fullname: fullname!)
    }
    
    func handelUserRegisteration(userEmail: String, userPassword: String, fullname: String) {
        
        let activiteIndecator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activiteIndecator.center = view.center
        activiteIndecator.hidesWhenStopped = false
        view.addSubview(activiteIndecator)
        activiteIndecator.startAnimating()
        
        Communication.sharedInstance.userRegister(email: userEmail, fullname: fullname, password: userPassword) { (registered, id) in
            if registered {
                
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

extension UIViewController {
    func showAlertBox(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func isValidEmail(testStr: String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
