//
//  StatusItemView.swift
//  CryptoSpace
//
//  Created by Pitchmak Sareerat on 8/4/2560 .
//  Copyright © 2560 Finnomena. All rights reserved.
//

import AppKit
import Foundation

class StatusItemView: NSControl {
    var fontSize: CGFloat = 9
    var fontColor = NSColor.black
    var darkMode = false
    var statusItem: NSStatusItem

    var rate = "OMG: - THB"

    init(statusItem aStatusItem: NSStatusItem) {
        statusItem = aStatusItem
        super.init(frame: NSMakeRect(0, 0, statusItem.length, 30))

        darkMode = SystemThemeChangeHelper.isCurrentDark()
        SystemThemeChangeHelper.addRespond(target: self, selector: #selector(changeMode))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ dirtyRect: NSRect) {
        fontColor = darkMode ? NSColor.white : NSColor.black

        let fontAttributes = [NSFontAttributeName: NSFont.systemFont(ofSize: fontSize), NSForegroundColorAttributeName: fontColor] as [String : Any]
        let rateString = NSAttributedString(string: rate, attributes: fontAttributes)
        let rateRact = rateString.boundingRect(with: NSSize(width: 100, height: 100), options: .usesLineFragmentOrigin)
        rateString.draw(at: NSPoint(x: bounds.width - rateRact.width - 5, y: 5))
    }

    func setRateData(_ data: Double) {
        rate = formatRateData(data)
        setNeedsDisplay()
    }

    func formatRateData(_ data: Double) -> String {
        return "OMG: " + String(format: "%.02f", data) + " THB"
    }

    func changeMode() {
        darkMode = SystemThemeChangeHelper.isCurrentDark()
        setNeedsDisplay()
    }
}
