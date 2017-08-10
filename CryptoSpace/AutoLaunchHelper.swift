//
//  AutoLaunchHelper.swift
//  CryptoSpace
//
//  Created by Pitchmak Sareerat on 8/10/2560 .
//  Copyright © 2560 Finnomena. All rights reserved.
//

import Foundation

class AutoLaunchHelper {
    static func isLaunchWhenLogin() -> Bool {
        return (loginItem() != nil)
    }

    static func removeFromLoginItems() {
        guard let loginItem = loginItem() else { return }
        let loginItemsFileList = LSSharedFileListCreate(nil,
                                                        kLSSharedFileListSessionLoginItems.takeRetainedValue(),
                                                        nil).takeRetainedValue() as LSSharedFileList?
        LSSharedFileListItemRemove(loginItemsFileList, loginItem)
        print("Application was removed from login items")
    }

    static func addToLoginItems() {
        let bundleURL = Bundle.main.bundleURL
        let loginItemsFileList = LSSharedFileListCreate(nil,
                                                        kLSSharedFileListSessionLoginItems.takeRetainedValue(),
                                                        nil).takeRetainedValue() as LSSharedFileList?
        guard loginItemsFileList != nil else { return }
        LSSharedFileListInsertItemURL(loginItemsFileList,
                                      kLSSharedFileListItemBeforeFirst.takeRetainedValue(),
                                      nil,
                                      nil,
                                      bundleURL as CFURL,
                                      nil,
                                      nil)
        print("Application was added to login items")
    }

    static func loginItem() -> LSSharedFileListItem? {
        let bundleURL = Bundle.main.bundleURL
        let loginItemsFileList = LSSharedFileListCreate(nil,
                                                        kLSSharedFileListSessionLoginItems.takeRetainedValue(),
                                                        nil).takeRetainedValue() as LSSharedFileList?
        guard loginItemsFileList != nil else { return nil }

        let loginItems = LSSharedFileListCopySnapshot(loginItemsFileList, nil).takeRetainedValue()

        for loginItem in loginItems as! [LSSharedFileListItem] {
            let itemURL = LSSharedFileListItemCopyResolvedURL(loginItem, 0, nil).takeRetainedValue() as NSURL
            if bundleURL.absoluteString == itemURL.absoluteString {
                return loginItem
            }
        }
        return nil
    }

    static func toggleLaunchWhenLogin() {
        if isLaunchWhenLogin() {
            removeFromLoginItems()
        } else {
            addToLoginItems()
        }
    }
}
