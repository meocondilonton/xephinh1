//
//  AppDelegate.swift
//  Switris
//
//  Created by Mathieu Vandeginste on 10/05/2016.
//  Copyright © 2016 Mathieu Vandeginste. All rights reserved.
//

import UIKit

let is_ipad = UIDevice.currentDevice().userInterfaceIdiom == .Pad ? true : false
struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    //screen reslution
    static let IS_IPAD = UIDevice.currentDevice().userInterfaceIdiom == .Pad
    static let IS_IPHONE = UIDevice.currentDevice().userInterfaceIdiom == .Phone
    static let IS_RETINA = UIScreen.mainScreen().scale >= 2.0
    
    static let IS_IPHONE_4_OR_LESS = (ScreenSize.IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH < 568.0)
    static let IS_IPHONE_5_OR_LESS = (ScreenSize.IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH <= 568.0)
    static let IS_IPHONE_5 = (ScreenSize.IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH == 568.0)
    static let IS_IPHONE_6_OR_MORE = (ScreenSize.IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH >= 667.0)
    static let IS_IPHONE_6 = (ScreenSize.IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH == 667.0)
    static let IS_IPHONE_6P = (ScreenSize.IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH == 736.0)
    
    
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
         NSNotificationCenter.defaultCenter().postNotificationName("NotificationEnterBackground", object: nil)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
         NSNotificationCenter.defaultCenter().postNotificationName("NotificationEnterForeground", object: nil)
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

