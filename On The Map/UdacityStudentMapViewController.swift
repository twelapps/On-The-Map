//
//  UdacityStudentMapViewController.swift
//  On The Map
//
//  Created by Twelker on May/31/15.
//  Copyright (c) 2015 Twelker. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class UdacityStudentMapViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var errorMessage: UITextField! //Label type is not displayed before a map ?? Does not work in any case
    
    let studentInfoKeptHere = (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    let locationManager = CLLocationManager()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //************************************************************************************************
        // Use this routine to add TWO bar button items at the right hand side of the top navigation bar
        // (cannot be done in NIB)
        //************************************************************************************************
        var reloadBarButtonItem: UIBarButtonItem {
            return UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "reloadBarButtonItemClicked")
        }
        var pinBarButtonItem = UIBarButtonItem(title: "pin", style: .Plain, target: self, action: "pinBarButtonItemClicked")
        pinBarButtonItem.image = UIImage(named: "pin")
        
        let toolbarButtonItems = [reloadBarButtonItem, pinBarButtonItem]
        
        self.navigationItem.setRightBarButtonItems(toolbarButtonItems, animated: true)
        
        errorMessage.delegate=self
        
        mapView.delegate = self
        
        //******************************************
        // Now fill the map, first with my own pin
        //******************************************
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization() // +++ add to info.plist as well !!
        self.locationManager.startUpdatingLocation()
        
        fillMapWithMyInfo()
        fillMapWithStudentsInfo()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if studentInfoKeptHere.allUdacityStudentInfo.count == 0 {      // No student info
            self.throwMessage(UdacityDBClient.Constants.msgNoStudentInfo)
        }
        self.errorMessage.alpha = 0                                    // Do not display error message field
        self.errorMessage.text = UdacityDBClient.Constants.emptyString // Initiate error message field
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        self.throwMessage(UdacityDBClient.Constants.msgUpdateLocationProblem)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                self.throwMessage(UdacityDBClient.Constants.msgUpdateLocationProblem)
                return
            }
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                self.throwMessage(UdacityDBClient.Constants.msgFindLocationProblem)
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
        //stop updating location to save battery life
        locationManager.stopUpdatingLocation()
        
        // Save my current location info in AppDelegate.swift for later use and write to user defaults ("disk") as well
        UdacityDBClient().saveMyMapstring(placemark.locality + ", " + placemark.administrativeArea + ", " + placemark.country)
    }
    
    func fillMapWithMyInfo () {
        if locationManager.location != nil {
            
            // Fill callout on the map
            // Provide URL when specified before otherwise fill the callout with "I am here!"
            if studentInfoKeptHere.myUserInfo.mediaURL == UdacityDBClient.Constants.emptyString {
                placeAnnotationOnMap(locationManager.location.coordinate.latitude,
                    longitude: locationManager.location.coordinate.longitude,
                    title: UdacityDBClient.Constants.calloutTitle,
                    subtitle: UdacityDBClient.Constants.calloutSubTitle)
            } else {
                placeAnnotationOnMap(locationManager.location.coordinate.latitude,
                    longitude: locationManager.location.coordinate.longitude,
                    title: UdacityDBClient.Constants.calloutTitle,
                    subtitle: studentInfoKeptHere.myUserInfo.mediaURL)
            }
            
            // Save my latitude/longitude info in AppDelegate.swift for later use and write to user defaults ("disk") as well
            UdacityDBClient().saveMyLatLong(locationManager.location.coordinate.latitude,
                longitude: locationManager.location.coordinate.longitude)
            
        } else {
            // Could not obtain my location, do not put it on the map
        }

    }
    
    func fillMapWithStudentsInfo () {

        // Now fill the map with other student's information
        if studentInfoKeptHere.allUdacityStudentInfo.count > 0 {
            for student in studentInfoKeptHere.allUdacityStudentInfo {
                placeAnnotationOnMap(student.latitude,                          longitude: student.longitude,
                              title: student.firstName + " " + student.lastName, subtitle: student.mediaURL)
            }
        } else {
            // No student info retrieved, connectivity issue?
            self.throwMessage(UdacityDBClient.Constants.msgNoStudentInfo)
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
    
    func reloadBarButtonItemClicked() {
        UdacityDBClient().GETUdacityStudentInfo() { (success, errorString) in
            if success {
                dispatch_async(dispatch_get_main_queue(), {                    // Leave a-synchronous mode
                    self.mapView.removeAnnotations(self.mapView.annotations!)  // Remove previous annotations
                    self.fillMapWithMyInfo()
                    self.fillMapWithStudentsInfo()                             // Add renewed annotations
                }) //end of dispatch
            } else {
                // Bad luck, display unchanged data but throw message
                dispatch_async(dispatch_get_main_queue(), {                    // Leave a-synchronous mode
                    self.throwMessage(UdacityDBClient.Constants.msgNoStudentInfoUpdate)
                }) //end of dispatch
            } // of else
        } //end UdacityDBClient().GETUdacityStudentInfo() { (success, errorString) in
    } //end func reloadBarButtonItemClicked
    
    func pinBarButtonItemClicked() {
        let storyboard = self.storyboard
        let nextVC = storyboard!.instantiateViewControllerWithIdentifier("InfoPostingView") as! UIViewController
        self.presentViewController(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func logoutBarButtonItemClicked (sender: UIBarButtonItem) {
        // Reset my account info and display logon screen
        UdacityDBClient().resetMyCredentials()
        
        let storyboard = self.storyboard
        let nextVC = storyboard!.instantiateViewControllerWithIdentifier("loginViewController") as! UIViewController
        self.presentViewController(nextVC, animated: true, completion: nil)
    }
    
    // De-activate error message for input: it has been presented as text field but must not be editable!
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return false
    }
    
    func throwMessage (message: String) {
        self.view.endEditing(true)       // Always end editing first
        self.errorMessage.alpha = 1      // Display message field
        self.errorMessage.text = message
    }
}
