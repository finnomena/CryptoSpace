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
    let menu: NSMenu
    let currencyMenuItems: [NSMenuItem]
    let monitor: CryptoMonitor

    override init() {
        statusItem = NSStatusBar.system().statusItem(withLength: 96)

        menu = NSMenu()

        let currencies: [CryptoCurrency] = [.BTC, .ETH, .DAS, .REP, .GNO, .OMG]
        currencyMenuItems = currencies.map {
            NSMenuItem(title: $0.rawValue, action: #selector(currencyMenuItemClicked(_:)), keyEquivalent: "")
        }

        for menuItem in currencyMenuItems {
            menu.addItem(menuItem)
        }

        menu.addItem(NSMenuItem.separator())

        let autoLaunchMenuItem = NSMenuItem()
        autoLaunchMenuItem.title = "Launch when login"
        autoLaunchMenuItem.state = AutoLaunchHelper.isLaunchWhenLogin() ? 1 : 0
        autoLaunchMenuItem.action = #selector(autoLaunchMenuItemClicked(_:))
        menu.addItem(autoLaunchMenuItem)

        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(withTitle: "Quit", action: #selector(quitMenuItemClicked), keyEquivalent: "q")

        statusItemView = StatusItemView(statusItem: statusItem, menu: menu)
        statusItem.view = statusItemView

        monitor = CryptoMonitor(statusItemView: statusItemView)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        monitor.start()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

extension AppDelegate {
    func currencyMenuItemClicked(_ sender: NSMenuItem) {
        monitor.currency = CryptoCurrency(rawValue: sender.title) ?? CryptoCurrency.BTC
        currencyMenuItems.forEach { $0.state = 0 }
        sender.state = 1
    }
    func autoLaunchMenuItemClicked(_ sender: NSMenuItem) {
        AutoLaunchHelper.toggleLaunchWhenLogin()
        sender.state = AutoLaunchHelper.isLaunchWhenLogin() ? 1 : 0
    }
    func quitMenuItemClicked() {
        NSApp.terminate(nil)
    }
}
