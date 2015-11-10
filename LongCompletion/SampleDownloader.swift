//
//  SampleDownloader.swift
//  LongCompletion
//
//  Created by Max Goedjen on 11/10/15.
//  Copyright © 2015 Disney. All rights reserved.
//

import UIKit

class SampleDownloader: NSObject {
    
    // Yeah I know, a singleton, but it's just a sample project.
    static let sharedDownloader = SampleDownloader()
    
    var session: NSURLSession?
    var backgroundCompletionHandler: (Void -> Void)? = nil
    var runningDownloads: [NSURLSessionDownloadTask] = []
    
    private let transformerQueue = dispatch_queue_create("sampledownloader.transformer", nil)

    override init() {
        // This init requirement really sucks in this case
        session = NSURLSession()
        super.init()
        let config = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("SampleDownloader")
        config.allowsCellularAccess = false
        config.requestCachePolicy = .ReloadIgnoringLocalCacheData
        session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
        discoverDetached()
    }
    
    func download(url: NSURL) {
        guard let task = session?.downloadTaskWithURL(url) else { return }
        runningDownloads.append(task)
        task.resume()
    }
    
    func discoverDetached() {
        session?.getTasksWithCompletionHandler { _, _, tasks in
            self.runningDownloads = tasks
            UILocalNotification.debugMessage("Discovered", downloader: self)
        }
    }
    
    var downloadedPath: String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        return (documentsPath as NSString).stringByAppendingPathComponent("Downloads")
    }
    
}

extension SampleDownloader: NSURLSessionDelegate, NSURLSessionDownloadDelegate {
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        UILocalNotification.debugMessage("Finished \(downloadTask)", downloader: self)
        
        _ = try? NSFileManager.defaultManager().moveItemAtPath(location.path!, toPath: downloadedPath)

        // Here be dragons
        /* 
            Without this sleep, all's great, but any long running task in here (eg, unzipping a zip file) will block the delegate queue. That part's expected behavior.
            If the queue gets blocked, subesquent didFinishDownloadingToURL: messages won't get sent (again, expected). 
            Eventually, the app will time out (again, we're in the background, so expected behavior, I totally get how you don't want someone to start a bg task and then have indefinite bg time)
            Here's where it gets weird:
            If the messages DON'T get sent, the temp files (located a `location` passed in) still get deleted. There appears to be no way to recover those tasks or temp files if this happens. Basically, the bug is:
            If `didFinishDownloadingToURL` doesn't get called, the temp files shouldn't get purged, or those tasks should still be marked as pending (ie, discoverable via getTasksWithCompletionHandler)
        
        */
        
        // If you comment this sleep out, all will be good 🌈
        sleep(600)
        // We'll time out long before this executes
        UILocalNotification.debugMessage("Sync sleep complete", downloader: nil)
        
        
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("Write \(totalBytesWritten)/\(totalBytesExpectedToWrite)")
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        
    }
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
        dispatch_async(dispatch_get_main_queue()) {
            UILocalNotification.debugMessage("URLSessionFinished", downloader: nil)
            self.backgroundCompletionHandler?()
            self.backgroundCompletionHandler = nil
        }
    }
    
}