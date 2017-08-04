//
//  AppDelegate.swift
//  CryptoSpace
//
//  Created by Pitchmak Sareerat on 8/4/2560 .
//  Copyright © 2560 Finnomena. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem: NSStatusItem
    let statusItemView: StatusItemView

    override init() {
        statusItem = NSStatusBar.system().statusItem(withLength: 96)
        statusItemView = StatusItemView(statusItem: statusItem)
        statusItem.view = statusItemView
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        CryptoMonitor(statusItemView: statusItemView).start()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
