//
//  AppDelegate.swift
//  AmbiLiFi
//
//  Created by Georgios Andritsos on 01/10/2017.
//  Copyright © 2017 AppDVision. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var ambi = zAmbiLightController()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        ambi.setColor()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

