//
//  InfoPostingViewController.swift
//  On The Map
//
//  Created by Twelker on Jun/1/15.
//  Copyright (c) 2015 Twelker. All rights reserved.
//

//import Foundation
import UIKit


class InfoPostingViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var firstName   : UITextField!
    @IBOutlet weak var lastName    : UITextField!
    @IBOutlet weak var placeOfStudy: UITextView!
    @IBOutlet weak var errorMessage: UITextField!
    @IBOutlet weak var whereAreYou : UILabel!
    @IBOutlet weak var studying    : UILabel!
    @IBOutlet weak var today       : UILabel!
    @IBOutlet weak var findOnMap   : UIButton!
    
    let studentInfoKeptHere = (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer!.numberOfTapsRequired = 1
        
        errorMessage.delegate=self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated) // Give as parameter what the override func also received, here: animated.
        
        self.errorMessage.alpha   = 0             // Do not display error message field
        self.errorMessage.text    = UdacityDBClient.Constants.emptyString
        
        // Fill first and last name fields and map string field (place of study) when already set
        if self.studentInfoKeptHere.myUserInfo.firstName != UdacityDBClient.Constants.emptyString {
            firstName.text = self.studentInfoKeptHere.myUserInfo.firstName
        }
        if self.studentInfoKeptHere.myUserInfo.lastName != UdacityDBClient.Constants.emptyString {
            lastName.text = self.studentInfoKeptHere.myUserInfo.lastName
        }
        if self.studentInfoKeptHere.myUserInfo.mapString != UdacityDBClient.Constants.emptyString {
            placeOfStudy.text = self.studentInfoKeptHere.myUserInfo.mapString
        } else {
            self.throwMessage(UdacityDBClient.Constants.msgFindLocationProblem)
        }
        
        // Subscribe to keyboard notification in order to shift the view up or down (when needed) when keyboard appears/disappears
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Remove keyboard when tapped once outside the input fields
        self.view.addGestureRecognizer(tapRecognizer!)
        
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }

    
    @IBAction func backButtonItemClicked (sender: UIBarButtonItem) {
        
        let storyboard = self.storyboard
        let nextVC = storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        self.presentViewController(nextVC, animated: true, completion: nil)
        
    }
    
    @IBAction func findOnMapButtonClicked (sender: UIButton) {
        
        let storyboard = self.storyboard
        let nextVC = storyboard!.instantiateViewControllerWithIdentifier("MeOnMap") as! UIViewController
        self.presentViewController(nextVC, animated: true, completion: nil)
        
        // Save first name and last name and place of study in AppDelegate.swift for later use and write to user defaults ("disk") as well
        UdacityDBClient().saveMyName(firstName.text, lastName: lastName.text)
        UdacityDBClient().saveMyMapstring(placeOfStudy.text)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        // Move view up if the BOTTOM field is being edited
        if placeOfStudy.isFirstResponder() {
            self.view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        // Move view down if the BOTTOM field is ending being edited
        if placeOfStudy.isFirstResponder() {
            self.view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // De-activate error message for input: it has been presented as text field but must not be editable!
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == errorMessage {
            return false
        } else {
            return true
        }
    }
    
    func throwMessage (message: String) {
        self.view.endEditing(true)       // Always end editing first
        self.errorMessage.alpha = 1      // Display message field
        self.errorMessage.text = message

    }
    
}

