//
//  AppDelegate.swift
//  LongCompletion
//
//  Created by Max Goedjen on 11/9/15.
//  Copyright © 2015 Disney. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let settings = UIUserNotificationSettings(forTypes: .Alert, categories: nil)
        application.registerUserNotificationSettings(settings)
        SampleDownloader.sharedDownloader
        return true
    }

    func application(application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void) {
        SampleDownloader.sharedDownloader.backgroundCompletionHandler = completionHandler
    }

}

