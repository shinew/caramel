//
//  RegisterViewController.swift
//  Caramel
//
//  Created by James Sun on 2014-11-10.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class RegisterViewController: PortraitViewController, UITextFieldDelegate {
    
    @IBOutlet weak var introTextView: UITextView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    var userRecord: UserRecord!
    var shouldSegue = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.layer.cornerRadius = 5
        signUpButton.layer.borderColor = Conversion.UIColorFromRGB(13, green: 153, blue: 252).CGColor
        signUpButton.layer.borderWidth = 1
        
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderColor = Conversion.UIColorFromRGB(13, green: 153, blue: 252).CGColor
        loginButton.layer.borderWidth = 1
        
        //setting up textfield delegates
        self.userNameTextField.delegate = self
        self.passwordTextField.delegate = self
        
        
        //outside-clicking setup
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard:")))
    }
    
    @objc func dismissKeyboard(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        if textField == self.userNameTextField {
            self.passwordTextField.becomeFirstResponder()
        } else {
            self.passwordTextField.resignFirstResponder()
        }
        return true
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        if self.shouldSegue {
            return true
        }
        
        if self.userNameTextField.text == "" || self.passwordTextField.text == "" {
            self.introTextView.text = "Please complete all fields."
            self.introTextView.textColor = UIColor.redColor()
        } else if identifier == "signupSuccessSegue" {
            self.introTextView.text = "Signing up..."
            self.completeSignup()
        } else if identifier == "loginSuccessSegue" {
            self.introTextView.text = "Logging in..."
            self.completeLogin()
        }
        return false
    }
    
    func completeSignup() {
        println("(Onboarding) Completed signup. Sending auth to server.")
        self.signUpButton.enabled = false
        self.loginButton.enabled = false
        let userName = self.userNameTextField.text
        let password = self.passwordTextField.text
        self.userRecord = UserRecord(userName: userName, userID: nil, password: password)
        HTTPRequest.sendUserAddRequest(self.userRecord, responseCallback: self.signupCallback)
    }
    
    func signupCallback(response: NSHTTPURLResponse!, data: Agent.Data!, error: NSError!) -> Void {
        println("(Onboarding) finished sending sign-up onboarding request!")
        if response == nil {
            if InternetConnectivity.getInternetConnected() {
                InternetConnectivity.setInternetConnected(false)
                
                Notification.sendNoInternetNotification()
            }
            
            println("(Onboarding) Request did not go through")
            return
        }
        
        InternetConnectivity.setInternetConnected(true)
        
        println("(Onboarding) response status code: \(response.statusCode)")
        dispatch_async(dispatch_get_main_queue(), {
            self.signUpButton.enabled = true
            self.loginButton.enabled = true
        })
        if response.statusCode == 201 {
            let json = data as [String: AnyObject]
            let userID = json["ID"] as Int
            println("(Onboarding) Received new userID: \(userID)")
            User.setUserIDAndPassword(userID, password: self.userRecord.password!)
            self.shouldSegue = true
            dispatch_async(dispatch_get_main_queue(), {
                StartScreen.completedOnboarding()
                self.performSegueWithIdentifier("signupSuccessSegue", sender: self)
            })
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                self.introTextView.text = "Username already taken. Please try again."
            })
        }
    }
    
    func completeLogin() {
        println("(Onboarding) Completed login. Sending auth to server.")
        self.signUpButton.enabled = false
        self.loginButton.enabled = false
        let userName = self.userNameTextField.text
        let password = self.passwordTextField.text
        self.userRecord = UserRecord(userName: userName, userID: nil, password: password)
        HTTPRequest.sendUserVerifyRequest(self.userRecord, responseCallback: self.loginCallback)
    }
    
    func loginCallback(response: NSHTTPURLResponse!, data: Agent.Data!, error: NSError!) -> Void {
        println("(Onboarding) finished sending login onboarding request!")
        if response == nil {
            if InternetConnectivity.getInternetConnected() {
                InternetConnectivity.setInternetConnected(false)
                
                Notification.sendNoInternetNotification()
            }

            println("(Onboarding) Request did not go through")
            return
        }
        
        InternetConnectivity.setInternetConnected(true)
        
        println("(Onboarding) response status code: \(response.statusCode)")
        dispatch_async(dispatch_get_main_queue(), {
            self.signUpButton.enabled = true
            self.loginButton.enabled = true
        })
        if response.statusCode == 200 {
            let json = data as [String: AnyObject]
            let userID = json["ID"] as Int
            println("(Onboarding) Received old userID: \(userID)")
            User.setUserIDAndPassword(userID, password: self.userRecord.password!)
            self.shouldSegue = true
            self.sendBulkScoreRetrievalRequest()
            dispatch_async(dispatch_get_main_queue(), {
                StartScreen.completedOnboarding()
                self.performSegueWithIdentifier("loginSuccessSegue", sender: self)
            })
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                self.introTextView.text = "Wrong username/password. Please try again."
            })
        }
    }
    
    private func sendBulkScoreRetrievalRequest() {
        //retrieve the previous 24hrs worth of intervals
        println("Sending bulk stress request")
        var currentDate = NSDate()
        var yesterdayDate = currentDate.dateByAddingTimeInterval(-60 * 60 * 48)
        HTTPRequest.sendBulkStressRequest(yesterdayDate, endDate: currentDate, responseCallback: self.bulkScoreRetrievalCallback)
    }
    
    private func bulkScoreRetrievalCallback(response: NSHTTPURLResponse!, data: Agent.Data!, error: NSError!) -> Void {
        if response == nil {
            if InternetConnectivity.getInternetConnected() {
                InternetConnectivity.setInternetConnected(false)
                
                Notification.sendNoInternetNotification()
            }

            println("(Bulk Stress) Request did not go through")
            return
        }
        
        InternetConnectivity.setInternetConnected(true)
        
        println("(Bulk Stress) finished sending Stress request!")
        println("(Bulk Stress) response status code: \(response.statusCode)")
        if response != nil && response.statusCode == 200 {
            var bulkIntervals = [StressScoreInterval]()
            let json = data as [String: AnyObject]
            if json["Scores"] is [[String: AnyObject]] {
                let scores = json["Scores"] as [[String: AnyObject]]
                for score in scores {
                    let scoreInt: AnyObject? = score["Score"]
                    let startDate: AnyObject? = score["StartTime"]
                    let endDate: AnyObject? = score["EndTime"]
                    println("\(scoreInt), \(startDate), \(endDate)")
                    bulkIntervals.append(StressScoreInterval(
                        score: scoreInt as Int,
                        startDate: Conversion.stringToDate(startDate as String),
                        endDate: Conversion.stringToDate(endDate as String),
                        userID: User.getUserID()))
                }
            }
            Database.addBulkStressScoreInterval(bulkIntervals)
        }
    }
}
