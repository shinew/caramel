//
//  RegisterViewController.swift
//  Caramel
//
//  Created by James Sun on 2014-11-10.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    var userRecord: UserRecord!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Univers-Light-Bold", size: 18)!]

        signUpButton.layer.cornerRadius = 5
        signUpButton.layer.borderColor = Conversion.UIColorFromRGB(13, green: 153, blue: 252).CGColor
        signUpButton.layer.borderWidth = 1
        
        //setting up textfield delegates
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        if identifier == "loginSuccessSegue" && self.didCompleteSignup() {
            self.completeSignup()
            return true
        } else {
            self.signUpButton.setTitle("Please complete all fields.", forState: UIControlState.Normal)
            self.signUpButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
            self.signUpButton.layer.borderColor = UIColor.redColor().CGColor
            return false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        if textField == self.firstNameTextField {
            self.lastNameTextField.becomeFirstResponder()
        } else if textField == self.lastNameTextField {
            self.passwordTextField.becomeFirstResponder()
        } else {
            self.passwordTextField.resignFirstResponder()
        }
        return true
    }
    
    func didCompleteSignup() -> Bool {
        return self.firstNameTextField.text != "" && self.lastNameTextField.text != "" && self.passwordTextField.text != ""
    }
    
    func completeSignup() {
        println("(Onboarding) Received new name and password. Sending auth to server.")
        self.signUpButton.enabled = false
        self.signUpButton.setTitle("Thanks!", forState: UIControlState.Normal)
        let firstName = self.firstNameTextField.text
        let lastName = self.lastNameTextField.text
        let password = self.passwordTextField.text
        self.userRecord = UserRecord(firstName: firstName, lastName: lastName, userID: nil, password: password)
        HTTPRequest.sendUserAuthRequest(self.userRecord, responseCallback: self.receivedNewUserIDCallback)
    }
    
    func receivedNewUserIDCallback(response: NSHTTPURLResponse!, data: Agent.Data!, error: NSError!) -> Void {
        println("(Onboarding) finished sending Onboarding request!")
        if response == nil {
            println("(Onboarding) Request did not go through")
            return
        }
        println("(Onboarding) response status code: \(response.statusCode)")
        if response.statusCode == 201 {
            let json = data as [String: AnyObject]
            let userID = json["ID"] as Int
            println("(Onboarding) Received new userID: \(userID)")
            User.setUserIDAndPassword(userID, password: self.userRecord.password!)
        }
    }
}
