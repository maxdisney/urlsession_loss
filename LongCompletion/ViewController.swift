//
//  ViewController.swift
//  LongCompletion
//
//  Created by Max Goedjen on 11/9/15.
//  Copyright © 2015 Disney. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func download(sender: UIButton?) {
        let downloader = SampleDownloader.sharedDownloader
        downloader.download(NSURL(string: "https://github.com/Itseez/opencv/archive/3.0.0.zip")!)
        downloader.download(NSURL(string: "https://github.com/Itseez/opencv/archive/2.4.11.zip")!)
        downloader.download(NSURL(string: "https://github.com/Itseez/opencv/archive/2.4.10.zip")!)
    }

}

