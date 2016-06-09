//
//  AppDelegate.swift
//  NBAodds
//
//  Created by Ravi Lonberg on 4/6/16.
//  Copyright © 2016 Ravi Lonberg. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let hostName: String? = "xml.pinnaclesports.com"
    
    var window: UIWindow?
    
    var importantAlert: UIAlertController?
    var reachability: Reachability?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        initializeReachability(application)
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
    
    func initializeReachability(application: UIApplication) {
        
        NSNotificationCenter.defaultCenter().addObserverForName(kReachabilityChangedNotification, object: nil, queue: nil) {
            note in
            let reachability = note.object as! Reachability
            let notReachable = reachability.currentReachabilityStatus().rawValue == NotReachable.rawValue
            if notReachable || reachability.connectionRequired() {
                self.presentAlert()
            }
        }
        
        reachability = Reachability(hostName: hostName)
        
        
        reachability?.startNotifier()
        
    }
    
    
    func presentAlert() {
        // Will present network notification alert to the screen using UIAlertController
        
        //let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        if importantAlert == nil {
            importantAlert = UIAlertController(title: "Network Notification", message: "You are not connected to the internet", preferredStyle: .Alert)
            importantAlert!.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        }
        
        if importantAlert!.presentingViewController == nil {
            self.window?.rootViewController?.presentViewController(importantAlert!, animated: true, completion: nil)
        }
        
        
    }
    
    
}