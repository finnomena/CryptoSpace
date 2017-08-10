//
//  CryptoMonitor.swift
//  CryptoSpace
//
//  Created by Pitchmak Sareerat on 8/4/2560 .
//  Copyright © 2560 Finnomena. All rights reserved.
//

import Foundation

enum CryptoCurrency: String {
    case BTC = "1"
    case ETH = "21"
    case DAS = "22"
    case REP = "23"
    case GNO = "24"
    case OMG = "26"
}

class CryptoMonitor: NSObject {
    let statusItemView: StatusItemView
    let currency = CryptoCurrency.OMG

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
            guard error == nil else {
                print(error.debugDescription)
                return
            }
            guard (response as! HTTPURLResponse).statusCode == 200 else { return }

            do {
                guard let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] else { return }
                guard let currencyJSON = json[self.currency.rawValue] as? [String: Any],
                    let orderbookJSON = currencyJSON["orderbook"] as? [String: Any],
                    let bidsJSON = orderbookJSON["bids"] as? [String: Any],
                    let bid = bidsJSON["highbid"] as? Double
                    else {
                        return
                }
                self.handleData(bid)
            } catch {
                print("BX Unavailable")
            }
        }.resume()
    }

    func handleData(_ data: Double) {
        statusItemView.setRateData(data)
    }
}
