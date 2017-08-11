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
    let fontSize: CGFloat = 9
    var fontColor = NSColor.black
    var darkMode = false
    var mouseDown = false
    var statusItem: NSStatusItem

    var currency = CryptoCurrency.BTC {
        didSet {
            rate = "\(currency.rawValue): - THB"
            setNeedsDisplay()
        }
    }
    var rate = "\(CryptoCurrency.BTC.rawValue): - THB"

    init(statusItem aStatusItem: NSStatusItem, menu aMenu: NSMenu) {
        statusItem = aStatusItem
        super.init(frame: NSMakeRect(0, 0, statusItem.length, 30))
        menu = aMenu
        menu?.delegate = self

        darkMode = SystemThemeChangeHelper.isCurrentDark()
        SystemThemeChangeHelper.addRespond(target: self, selector: #selector(changeMode))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ dirtyRect: NSRect) {
        statusItem.drawStatusBarBackground(in: dirtyRect, withHighlight: mouseDown)

        fontColor = (darkMode || mouseDown) ? NSColor.white : NSColor.black

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
        return "\(currency.rawValue): " + String(format: "%.02f", data) + " THB"
    }

    func changeMode() {
        darkMode = SystemThemeChangeHelper.isCurrentDark()
        setNeedsDisplay()
    }
}

extension StatusItemView: NSMenuDelegate {
    override func mouseDown(with event: NSEvent) {
        guard let menu = menu else { return }
        statusItem.popUpMenu(menu)
    }

    func menuWillOpen(_ menu: NSMenu) {
        mouseDown = true
        setNeedsDisplay()
    }

    func menuDidClose(_ menu: NSMenu) {
        mouseDown = false
        setNeedsDisplay()
    }
}
