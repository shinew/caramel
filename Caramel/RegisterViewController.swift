//
//  RegisterViewController.swift
//  Caramel
//
//  Created by James Sun on 2014-11-10.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    var userRecord: UserRecord!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.layer.cornerRadius = 5
        signUpButton.layer.borderColor = Conversion.UIColorFromRGB(13, green: 153, blue: 252).CGColor
        signUpButton.layer.borderWidth = 1
        
        // Do any additional setup after loading the view.
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        if identifier == "loginSuccessSegue" && self.firstNameTextField.text != "" && self.lastNameTextField.text != "" && self.passwordTextField.text != "" {
            self.didCompleteSignup()
            return true
        } else {
            signUpButton.setTitle("Please complete all fields.", forState: UIControlState.Normal)
            signUpButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
            signUpButton.layer.borderColor = UIColor.redColor().CGColor
            return false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    func didCompleteSignup() {
        println("(Onboarding) Received new name and password. Sending auth to server.")
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
