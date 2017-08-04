//
//  CryptoMonitor.swift
//  CryptoSpace
//
//  Created by Pitchmak Sareerat on 8/4/2560 .
//  Copyright © 2560 Finnomena. All rights reserved.
//

import Foundation

class CryptoMonitor: NSObject {
    let statusItemView: StatusItemView

    init(statusItemView view: StatusItemView) {
        statusItemView = view
    }

    let interval: Double = 20

    func start() {
        Thread(target: self, selector: #selector(startUpdateTimer), object: nil).start()
    }

    func startUpdateTimer() {
        Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
        RunLoop.current.run()
    }

    func updateData() {
        // Get data from BX
        let url = URL(string: "https://bx.in.th/api/")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.allHTTPHeaderFields = ["cache-control": "no-cache"]
        URLSession.shared.dataTask(with: request) { data, response, error in
            if (response as! HTTPURLResponse).statusCode == 200 {
                let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]

                guard let omgJSON = json["26"] as? [String: Any],
                    let orderbookJSON = omgJSON["orderbook"] as? [String: Any],
                    let bidsJSON = orderbookJSON["bids"] as? [String: Any],
                    let bid = bidsJSON["highbid"] as? Double
                else {
                    return
                }
                self.handleData(bid)
            } else {
                if let error = error {
                    print(error)
                } else {
                    // no error
                }
            }
        }.resume()
    }

    func handleData(_ data: Double) {
        statusItemView.setRateData(data)
    }
}
