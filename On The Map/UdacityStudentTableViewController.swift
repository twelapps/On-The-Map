//
//  UdacityStudentTableViewController.swift
//  On The Map
//
//  Created by Twelker on May/30/15.
//  Copyright (c) 2015 Twelker. All rights reserved.
//

import Foundation
import UIKit

class UdacityStudentTableViewController: UIViewController {
    
    @IBOutlet weak var myTableView  : UITableView!
    
    let studentInfoKeptHere = (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use this routine to add TWO bar button items at the right hand side of the top navigation bar
        // (cannot be done in NIB)
        var reloadBarButtonItem: UIBarButtonItem {
            return UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "reloadBarButtonItemClicked")
        }
        var pinBarButtonItem = UIBarButtonItem(title: "pin", style: .Plain, target: self, action: "pinBarButtonItemClicked")
        pinBarButtonItem.image = UIImage(named: "pin")
        
        let toolbarButtonItems = [reloadBarButtonItem, pinBarButtonItem]
        
        self.navigationItem.setRightBarButtonItems(toolbarButtonItems, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return studentInfoKeptHere.allUdacityStudentInfo.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> StudentTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? StudentTableViewCell
        
        if cell != nil {
            cell!.nameLabel.text = studentInfoKeptHere.allUdacityStudentInfo[indexPath.row].firstName + " " +
                                   studentInfoKeptHere.allUdacityStudentInfo[indexPath.row].lastName
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Deselect the selected row otherwise the background of the selected row remains grey
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // Open student provided URL
        let url = studentInfoKeptHere.allUdacityStudentInfo[indexPath.row].mediaURL
        if UdacityDBClient().verifyUrl(url) {
            UIApplication.sharedApplication().openURL(NSURL(string: url)!)
        }
    }
    
    func reloadBarButtonItemClicked() {
        UdacityDBClient().GETUdacityStudentInfo() { (success, errorString) in
            if success {
                dispatch_async(dispatch_get_main_queue(), {                    // Leave a-synchronous mode
                    self.myTableView.reloadData()                              // reload table data
                })
            } else {
                // Bad luck, display unchanged data
            }
        }
    }
    
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
    
}

