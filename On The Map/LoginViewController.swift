//
//  LoginViewController.swift
//  On The Map
//
//  Created by Twelker on May/25/15.
//  Copyright (c) 2015 Twelker. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userID      : UITextField!
    @IBOutlet weak var password    : UITextField!
    @IBOutlet weak var messageField: UILabel!
    
    let studentInfoKeptHere = (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    var tapRecognizer: UITapGestureRecognizer? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer!.numberOfTapsRequired = 1
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // If already logged on previously, skip logon now
        if studentInfoKeptHere.myUserInfo.accountKey != UdacityDBClient.Constants.emptyString {
            self.retrieveUdacityStudentInfo()
        } else {
            
            // Remove keyboard when tapped once outside the userID or password input fields
            self.view.addGestureRecognizer(tapRecognizer!)
            
            throwMessage(UdacityDBClient.Constants.emptyString)          // End editing and reset message field
        }
    }
    
    @IBAction func signUpWithUdacity (sender: UIButton) {
        
        throwMessage(UdacityDBClient.Constants.emptyString)              // End editing and reset message field
        
        UIApplication.sharedApplication().openURL(NSURL(string: UdacityDBClient.Constants.UdacityHomePageURL)!)
    }

    
    @IBAction func loginUdacity (sender: UIButton) {
        
        self.view.endEditing(true)                                       // Always end editing first
        throwMessage(UdacityDBClient.Constants.emptyString)              // Reset message field
        
        if userID.text != UdacityDBClient.Constants.emptyString && password.text != UdacityDBClient.Constants.emptyString {
    
            let loginUdacity = UdacityDBClient()
            loginUdacity.login(userID.text, password: password.text) { (success, errorString) in
                if success {
                    // Now retrieve the Udacity student information
                    self.retrieveUdacityStudentInfo()
                } else {
                    self.throwMessage(errorString!)
                }
            }
        } else {
            self.throwMessage(UdacityDBClient.Constants.msgNoUserIDAndOrPassword)
        }
    }
    
    func retrieveUdacityStudentInfo () {
        // Student info is quite dynamic so it will not be saved between my sessions but will be retrieved instead
        UdacityDBClient().GETUdacityStudentInfo() { (success, errorString) in }
        
        // Do not check success, always navigate to next view controller and check there for successful student info
        // otherwise the logon view may pop-up unexpectedly
        dispatch_async( dispatch_get_main_queue(), { self.navToNextVC() } )
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    func throwMessage (message: String) {
        self.view.endEditing(true)                                       // Always end editing first
        dispatch_async(dispatch_get_main_queue(), {
            self.messageField.text = message
        })
    }
    
    func navToNextVC () {
        // Navigate to the MapViewController (via the navigation controller)
        let storyboard = self.storyboard
        let nextVC = storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        self.presentViewController(nextVC, animated: true, completion: nil)
    }
    
}

