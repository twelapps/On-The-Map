//
//  UdacityDBConstants.swift
//  On The Map
//
//  Created by Twelker on May/27/15.
//  Copyright (c) 2015 Twelker. All rights reserved.
//

import Foundation

extension UdacityDBClient {
    
    // MARK: - Constants
    struct Constants {
        
        static let emptyString              : String = ""
        static let zeroDouble               : Double = 0
        static let userID                   : String = "userID"
        static let password                 : String = "password"
        static let accountKey               : String = "accountKey"
        static let objectId                 : String = "objectId"
        static let uniqueKey                : String = "uniqueKey"
        static let firstName                : String = "firstName"
        static let lastName                 : String = "lastName"
        static let mapString                : String = "mapString"
        static let mediaURL                 : String = "mediaURL"
        static let latitude                 : String = "latitude"
        static let longitude                : String = "longitude"
        static let keyAccount               : String = "account"
        static let keyKey                   : String = "key"
        static let keyError                 : String = "error"
        static let keyResults               : String = "results"
        static let calloutTitle             : String = "Me"
        static let calloutSubTitle          : String = "I am here!"
        static let msgNoUserIDAndOrPassword : String = "No userID and/or password entered"
        static let msgNoInternet            : String = "Login failed. No Internet?"
        static let msgNoAccountKeyFound     : String = "No account key found"
        static let msgNoErrorCodeFound      : String = "No error code found"
        static let msgParsingError          : String = "Parsing error"
        static let msgNoUdacityAccess       : String = "No Udacity access. No Internet?"
        static let msgFindLocationProblem   : String = "Error finding location. No Internet?"
        static let msgUpdateLocationProblem : String = "Error updating location. No Internet?"
        static let msgInvalidURL            : String = "Invalid URL"
        static let msgNoStudentInfo         : String = "No student info available. No Internet?"
        static let msgNoStudentInfoUpdate   : String = "No new info available. No Internet?"
        static let msgMyInfoUpdateError     : String = "Error updating my info. No Internet?"
        static let UdacityHomePageURL       : String = "https://www.udacity.com/account/auth#!/signup"
        static let myUserInfoDataKey        : String = "myUserInfoDataKey"
        static let maxNrStudents            : String = "?limit=100"
    }

}
