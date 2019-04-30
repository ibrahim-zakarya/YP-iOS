//
//  ResetPasswordViewController.swift
//  Blogy
//
//  Created by admin on 23/09/2017.
//  Copyright © 2017 malekmouzayen. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

    @IBAction func sendButtonPressed(_ sender: UIButton) {
        let userEmail = userEmailTextField.text
        
        if userEmail == "" {
            showAlertBox(title: "Missing field", message: "Email field is empty")
            return
        } else if !isValidEmail(testStr: userEmail!){
            showAlertBox(title: "Wrong email", message: "The email addresse is not valied")
            return
        }
        handelResetUserPassword(userEmail: userEmail!)
    }
    
    func handelResetUserPassword(userEmail: String) {
        print("handel reset password")
    }

}
