//
//  MeOnMapViewController.swift
//  On The Map
//
//  Created by Twelker on Jun/1/15.
//  Copyright (c) 2015 Twelker. All rights reserved.
//

import UIKit
import MapKit


class MeOnMapViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var myUrl       : UITextView!
    @IBOutlet weak var errorMessage: UITextField! //Label type is not displayed before a map
    @IBOutlet weak var submit      : UIButton!
    @IBOutlet weak var mapView: MKMapView!

    
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    let studentInfoKeptHere = (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer!.numberOfTapsRequired = 1
        
        errorMessage.delegate = self
        
        fillMapWithMyInfo() // Place my location and info on the map
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Add "edit table entries" function
        self.errorMessage.alpha = 0             // Do not display place of study input field
        self.errorMessage.text  = UdacityDBClient.Constants.emptyString
        
        if studentInfoKeptHere.myUserInfo.mediaURL != UdacityDBClient.Constants.emptyString {
            self.myUrl.text = studentInfoKeptHere.myUserInfo.mediaURL  // Display saved mediaURL string
        }
        
        mapView.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Remove keyboard when tapped once outside the input fields
        self.view.addGestureRecognizer(tapRecognizer!)
        
    }
    
    func fillMapWithMyInfo () {
        
        // Provide URL when specified before otherwise fill the callout with "I am here!"
        var url_data = String()
        if studentInfoKeptHere.myUserInfo.mediaURL == UdacityDBClient.Constants.emptyString {
            url_data = UdacityDBClient.Constants.calloutSubTitle
        } else {
            url_data = studentInfoKeptHere.myUserInfo.mediaURL
        }
            // Fill callout on the map
        
            if studentInfoKeptHere.myUserInfo.latitude != UdacityDBClient.Constants.zeroDouble {
                placeAnnotationOnMap(studentInfoKeptHere.myUserInfo.latitude,
                          longitude: studentInfoKeptHere.myUserInfo.longitude,
                              title: UdacityDBClient.Constants.calloutTitle,
                           subtitle: url_data)
            } else {
                // Bad luck, my info not found, let it empty on the map
            }
    }
    
    func placeAnnotationOnMap(latitude: CLLocationDegrees, longitude: CLLocationDegrees, title: String, subtitle: String)  {
        var pos: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude,longitude)
        let posAnnot = MKPointAnnotation()
        posAnnot.coordinate = pos
        posAnnot.title = title
        posAnnot.subtitle = subtitle
        self.mapView.addAnnotation(posAnnot)
    }

    // Note: mapView function included in extension in Swift file UdacityStudentInfo
    
    @IBAction func backButtonItemClicked (sender: UIBarButtonItem) {
        
        let storyboard = self.storyboard
        let nextVC = storyboard!.instantiateViewControllerWithIdentifier("InfoPostingView") as! UIViewController
        self.presentViewController(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func submitButtonItemClicked (sender: UIButton) {
        
        self.view.endEditing(true)                                     // Always end editing first
        self.errorMessage.text = UdacityDBClient.Constants.emptyString // Initiate message field
        
        // SAVE STUFF BOTH TO DISK AND TO UDACITY
    
        if UdacityDBClient().verifyUrl(self.myUrl.text) {
            UdacityDBClient().saveMyMediaURL(self.myUrl.text)
            
            let updateUdacity = UdacityDBClient()
            updateUdacity.PUTUdacityStudentInfo() { (success, errorString) in
                if success {
                    // well, success: navigate to all-students map
                    let storyboard = self.storyboard
                    let nextVC = storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
                    self.presentViewController(nextVC, animated: true, completion: nil)
                } else {
                    dispatch_async(dispatch_get_main_queue(), {                    // Leave a-synchronous mode
                        self.throwMessage(errorString!)
                    })
                }
            }
        } else {
            self.throwMessage(UdacityDBClient.Constants.msgInvalidURL)
        }
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
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
        self.view.endEditing(true)
        self.errorMessage.alpha = 1      // Display message field// Always end editing first
        self.errorMessage.text = message
    }
    
}

