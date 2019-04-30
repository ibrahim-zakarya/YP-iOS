//
//  SendMessageViewController.swift
//  yp-ios
//
//  Created by Ibrahim Zakarya on 2/17/18.
//  Copyright © 2018 Ibrahim Zakarya. All rights reserved.
//

import UIKit
import Toast_Swift

class SendMessageViewController: UIViewController {
    
    @IBOutlet weak var subjectTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var messageTV: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        let userEmail = emailTF.text
        let subject = subjectTF.text
        let message = messageTV.text
        let user = User.getUserInfo()
        
        if userEmail == "" {
            showAlertBox(title: "Missing Fields", message: "Email field is empty")
            return
        } else if !isValidEmail(testStr: userEmail!){
            showAlertBox(title: "Wrong Email", message: "The email addresse is not valied")
            return
        } else if subject == "" {
            showAlertBox(title: "Missing Fields", message: "Subject field is empty")
            return
        } else if message == "" {
            showAlertBox(title: "Missing Fields", message: "Message field is empty")
            return
        }
        Communication.sharedInstance.sendMessage(message: message!, email: userEmail!, subject: subject!, userId: user?.userId) { (sent) in
            if sent {
                self.view.makeToast("Sent successfully")
                self.emailTF.text = ""
                self.subjectTF.text = ""
                self.messageTV.text = ""
                
            } else {
                self.view.makeToast("There is an error sending message")
            }
        }
        
    }
}
