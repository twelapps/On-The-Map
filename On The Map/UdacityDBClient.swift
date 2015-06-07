//
//  UdacityDBClient.swift
//  On The Map
//
//  Created by Twelker on May/27/15.
//  Copyright (c) 2015 Twelker. All rights reserved.
//

import Foundation
import UIKit

class UdacityDBClient : NSObject {
    
    let studentInfoKeptHere = (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    func login(userID: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(userID)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                completionHandler(success: false, errorString: UdacityDBClient.Constants.msgNoInternet)
                return
            } else {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                
                // Parse the data
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                
                if parsingError == nil {
                    if let accountData = parsedResult.valueForKey(Constants.keyAccount) as? NSDictionary {
                        
                        // Retrieve the account key from the account data
                        if let accountKey = accountData.valueForKey(Constants.keyKey) as? String {

                            // Save my logon data
                            self.saveMyCredentials(userID, password: password, accountKey: accountKey)
                            
                            completionHandler(success: true, errorString: Constants.emptyString)
                            
                        } else {
                            completionHandler(success: false, errorString: Constants.msgNoAccountKeyFound)
                        }
                    } else {
                        
                        if let errorMessage = parsedResult.valueForKey(Constants.keyError) as? String {
                            
                            completionHandler(success: false, errorString: errorMessage)
                        } else {
                            completionHandler(success: false, errorString: Constants.msgNoErrorCodeFound)
                        }
                    }
                } else {
                    completionHandler(success: false, errorString: Constants.msgParsingError)
                }
            }
        }
        task.resume()
        
    }

    
    func GETUdacityStudentInfo(completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        var request = NSMutableURLRequest(URL: NSURL(string:
            "https://api.parse.com/1/classes/StudentLocation\(Constants.maxNrStudents)")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                completionHandler(success: false, errorString: UdacityDBClient.Constants.msgNoUdacityAccess)
                return
            } else {
            
            // Parse the data
            var parsingError: NSError? = nil
            let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as? NSDictionary
            
            if parsingError == nil {
                if let studentsDirectory = parsedResult!.valueForKey(Constants.keyResults) as? [[String: AnyObject]] {

                    self.studentInfoKeptHere.allUdacityStudentInfo =
                                                              UdacityStudentInfo.studentsFromResults(studentsDirectory)
                    for student in self.studentInfoKeptHere.allUdacityStudentInfo {
                        let res = student.firstName + " " + student.lastName
                    }
                    completionHandler(success: true, errorString: Constants.emptyString) // Return success indicator
                } else {
                    if let errorMessage = parsedResult!.valueForKey(Constants.keyError) as? String {
                        completionHandler(success: false, errorString: errorMessage)
                    } else {
                        completionHandler(success: false, errorString: Constants.msgNoErrorCodeFound)
                    }
                }
            } else {
                completionHandler(success: false, errorString: Constants.msgParsingError)
            }
            } // of "let task =", the task definition. Now execute it.
        }
        task.resume()
    
    }
    
    func PUTUdacityStudentInfo(completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"\(studentInfoKeptHere.myUserInfo.uniqueKey)\", \"firstName\": \"\(studentInfoKeptHere.myUserInfo.firstName)\", \"lastName\": \"\(studentInfoKeptHere.myUserInfo.lastName)\",\"mapString\": \"\(studentInfoKeptHere.myUserInfo.mapString)\", \"mediaURL\": \"\(studentInfoKeptHere.myUserInfo.mediaURL)\",\"latitude\": \(studentInfoKeptHere.myUserInfo.latitude), \"longitude\": \(studentInfoKeptHere.myUserInfo.longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                completionHandler(success: false, errorString: Constants.msgMyInfoUpdateError)
            } else {
               completionHandler(success: true, errorString: Constants.emptyString)
            }
        }
        task.resume()
    }
    
    func resetMyCredentials() {
        // Reset all my information
        studentInfoKeptHere.myUserInfo = UdacityUserInfo()
        NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(studentInfoKeptHere.myUserInfo), forKey: UdacityDBClient.Constants.myUserInfoDataKey)
    }
    
    func saveMyCredentials(userID: String, password: String, accountKey: String) {
        studentInfoKeptHere.myUserInfo.userID     = userID
        studentInfoKeptHere.myUserInfo.password   = password
        studentInfoKeptHere.myUserInfo.accountKey = accountKey
        studentInfoKeptHere.myUserInfo.uniqueKey  = userID
        NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(studentInfoKeptHere.myUserInfo), forKey: UdacityDBClient.Constants.myUserInfoDataKey)
    }
    
    func saveMyLatLong(latitude: Double, longitude: Double) {
        studentInfoKeptHere.myUserInfo.latitude  = latitude
        studentInfoKeptHere.myUserInfo.longitude = longitude
        NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(studentInfoKeptHere.myUserInfo), forKey: UdacityDBClient.Constants.myUserInfoDataKey)
    }
    
    func saveMyMapstring(mapstring: String) {
        studentInfoKeptHere.myUserInfo.mapString = mapstring
        NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(studentInfoKeptHere.myUserInfo), forKey: UdacityDBClient.Constants.myUserInfoDataKey)
    }
    
    func saveMyName(firstName: String, lastName: String) {
        studentInfoKeptHere.myUserInfo.firstName = firstName
        studentInfoKeptHere.myUserInfo.lastName  = lastName
        NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(studentInfoKeptHere.myUserInfo), forKey: UdacityDBClient.Constants.myUserInfoDataKey)
    }
    
    func saveMyMediaURL(mediaURL: String) {
        studentInfoKeptHere.myUserInfo.mediaURL = mediaURL
        NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(studentInfoKeptHere.myUserInfo), forKey: UdacityDBClient.Constants.myUserInfoDataKey)
    }

    func verifyUrl(urlString: String?) ->Bool{
        //Check for nil
        if let urlString = urlString{
            //Create NSURL instance
            if let url = NSURL(string: urlString){
                //Check if your application can open the NSURL instance
                if UIApplication.sharedApplication().canOpenURL(url){
                    return true
                } else { return false }
            } else { return false }
        } else { return false }
    }

}