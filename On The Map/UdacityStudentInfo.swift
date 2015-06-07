//
//  UdacityStudentInfo.swift
//  On The Map
//
//  Created by Twelker on May/31/15.
//  Copyright (c) 2015 Twelker. All rights reserved.
//

import UIKit

struct UdacityStudentInfo {
    
    var objectId:  String = UdacityDBClient.Constants.emptyString
    var uniqueKey: String = UdacityDBClient.Constants.emptyString // should be populated with Udacity account user ID
    var firstName: String = UdacityDBClient.Constants.emptyString
    var lastName:  String = UdacityDBClient.Constants.emptyString
    var mapString: String = UdacityDBClient.Constants.emptyString // The location string used for geocoding the student location e.g. Mountain View, CA
    var mediaURL:  String = UdacityDBClient.Constants.emptyString // The URL provided by the student
    var latitude:  Double = UdacityDBClient.Constants.zeroDouble
    var longitude: Double = UdacityDBClient.Constants.zeroDouble
    
    init(dictionary: [String : AnyObject]) {
        objectId  = dictionary[UdacityDBClient.Constants.objectId]  as! String
        uniqueKey = dictionary[UdacityDBClient.Constants.uniqueKey] as! String
        firstName = dictionary[UdacityDBClient.Constants.firstName] as! String
        lastName  = dictionary[UdacityDBClient.Constants.lastName]  as! String
        mapString = dictionary[UdacityDBClient.Constants.mapString] as! String
        mediaURL  = dictionary[UdacityDBClient.Constants.mediaURL]  as! String
        latitude  = dictionary[UdacityDBClient.Constants.latitude]  as! Double
        longitude = dictionary[UdacityDBClient.Constants.longitude] as! Double
    }
    
    static func studentsFromResults(results: [[String : AnyObject]]) -> [UdacityStudentInfo] {
        
        var students = [UdacityStudentInfo]()
        
        /* Iterate through array of dictionaries; each student is a dictionary */
        for result in results {
            students.append(UdacityStudentInfo(dictionary: result))
        }
        
        return students
    }
    
}
