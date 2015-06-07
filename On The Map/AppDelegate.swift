//
//  AppDelegate.swift
//  On The Map
//
//  Created by Twelker on May/25/15.
//  Copyright (c) 2015 Twelker. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // Define and initialize the Shared Model here! Can be accessed from anywhere inside the project.
//    var myUserInfo            = UdacityUserInfo(userID: UdacityDBClient.Constants.emptyString,
//                                              password: UdacityDBClient.Constants.emptyString,
//                                            accountKey: UdacityDBClient.Constants.emptyString)
    var myUserInfo            = UdacityUserInfo()
    var allUdacityStudentInfo = [UdacityStudentInfo]()
    
    let defaults              = NSUserDefaults.standardUserDefaults()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Retrieve userdata saved to disk during previous sessions from disk
        self.restoreData()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        // User data was already saved. Now enforce synchronization with the user defaults (= write to disk) at this point.
        defaults.synchronize()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func restoreData() {
        
        if defaults.dataForKey(UdacityDBClient.Constants.myUserInfoDataKey) != nil {
            myUserInfo = NSKeyedUnarchiver.unarchiveObjectWithData(defaults.dataForKey(UdacityDBClient.Constants.myUserInfoDataKey)!) as! UdacityUserInfo
        }
        
    }



}

