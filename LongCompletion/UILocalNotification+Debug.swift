//
//  UILocalNotification+Debug.swift
//  LongCompletion
//
//  Created by Max Goedjen on 11/10/15.
//  Copyright © 2015 Disney. All rights reserved.
//

import UIKit

extension UILocalNotification {
    
    class func debugMessage(message: String, downloader: SampleDownloader?) {
        let localNotification = UILocalNotification()
        let running = downloader?.runningDownloads.map({ $0.currentRequest!.URL!.lastPathComponent! }).joinWithSeparator(",") ?? ""
        let full = "\(message) \(running)"
        print(full)
        localNotification.alertBody = full
        UIApplication.sharedApplication().presentLocalNotificationNow(localNotification)
    }
    
}
