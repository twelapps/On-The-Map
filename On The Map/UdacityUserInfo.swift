//
//  UdacityUserInfo.swift
//  On The Map
//
//  Created by Twelker on May/30/15.
//  Copyright (c) 2015 Twelker. All rights reserved.
//

import Foundation
import UIKit

class UdacityUserInfo : NSObject, NSCoding {
    var userID    : String
    var password  : String
    var accountKey: String
    var objectId  : String
    var uniqueKey : String
    var firstName : String
    var lastName  : String
    var mapString : String
    var mediaURL  : String
    var latitude  : Double
    var longitude : Double
    
    override init () {
        self.userID     = UdacityDBClient.Constants.emptyString
        self.password   = UdacityDBClient.Constants.emptyString
        self.accountKey = UdacityDBClient.Constants.emptyString
        self.objectId   = UdacityDBClient.Constants.emptyString
        self.uniqueKey  = UdacityDBClient.Constants.emptyString
        self.firstName  = UdacityDBClient.Constants.emptyString
        self.lastName   = UdacityDBClient.Constants.emptyString
        self.mapString  = UdacityDBClient.Constants.emptyString
        self.mediaURL   = UdacityDBClient.Constants.emptyString
        self.latitude   = UdacityDBClient.Constants.zeroDouble
        self.longitude  = UdacityDBClient.Constants.zeroDouble
    }
    
    // NSCoding, required for saving data to user defaults
    
    required init(coder decoder: NSCoder) {
        
        self.userID     = decoder.decodeObjectForKey(UdacityDBClient.Constants.userID)     as! String
        self.password   = decoder.decodeObjectForKey(UdacityDBClient.Constants.password)   as! String
        self.accountKey = decoder.decodeObjectForKey(UdacityDBClient.Constants.accountKey) as! String
        self.objectId   = decoder.decodeObjectForKey(UdacityDBClient.Constants.objectId)   as! String
        self.uniqueKey  = decoder.decodeObjectForKey(UdacityDBClient.Constants.uniqueKey)  as! String
        self.firstName  = decoder.decodeObjectForKey(UdacityDBClient.Constants.firstName)  as! String
        self.lastName   = decoder.decodeObjectForKey(UdacityDBClient.Constants.lastName)   as! String
        self.mapString  = decoder.decodeObjectForKey(UdacityDBClient.Constants.mapString)  as! String
        self.mediaURL   = decoder.decodeObjectForKey(UdacityDBClient.Constants.mediaURL)   as! String
        self.latitude   = decoder.decodeObjectForKey(UdacityDBClient.Constants.latitude)   as! Double
        self.longitude  = decoder.decodeObjectForKey(UdacityDBClient.Constants.longitude)  as! Double

        super.init()
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.userID,     forKey: UdacityDBClient.Constants.userID)
        coder.encodeObject(self.password,   forKey: UdacityDBClient.Constants.password)
        coder.encodeObject(self.accountKey, forKey: UdacityDBClient.Constants.accountKey)
        coder.encodeObject(self.objectId,   forKey: UdacityDBClient.Constants.objectId)
        coder.encodeObject(self.uniqueKey,  forKey: UdacityDBClient.Constants.uniqueKey)
        coder.encodeObject(self.firstName,  forKey: UdacityDBClient.Constants.firstName)
        coder.encodeObject(self.lastName,   forKey: UdacityDBClient.Constants.lastName)
        coder.encodeObject(self.mapString,  forKey: UdacityDBClient.Constants.mapString)
        coder.encodeObject(self.mediaURL,   forKey: UdacityDBClient.Constants.mediaURL)
        coder.encodeObject(self.latitude,   forKey: UdacityDBClient.Constants.latitude)
        coder.encodeObject(self.longitude,  forKey: UdacityDBClient.Constants.longitude)
    }
    
}