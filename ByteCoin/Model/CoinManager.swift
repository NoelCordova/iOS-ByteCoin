//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Noel Espino Córdova on 02/08/20.
//  Copyright © 2020 slingercode. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate: class {

    func didUpdateCurrencyRate(_ coinManager: CoinManager, coin: CoinModel)

    func didFailWithError(_ error: Error)

}

struct CoinManager {

    weak var delegate: CoinManagerDelegate?

    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = ""
    var currency = ""

    let currencyArray = [
        "AUD",
        "BRL",
        "CAD",
        "CNY",
        "EUR",
        "GBP",
        "HKD",
        "IDR",
        "ILS",
        "INR",
        "JPY",
        "MXN",
        "NZD",
        "PLN",
        "RON",
        "RUB",
        "SEK",
        "SGD",
        "USD",
        "ZAR"
    ]

    mutating func getCoinPrice(for currency: String) {
        self.currency = currency

        let url = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        fetch(with: url)
    }

    private func fetch(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)

            let task = session.dataTask(with: url, completionHandler: { (data, _, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }

                if let apiResponse = data {
                    if let coin = self.parseJSON(data: apiResponse) {
                        self.delegate?.didUpdateCurrencyRate(self, coin: coin)
                    }
                }
            })

            task.resume()
        }
    }

    private func parseJSON(data: Data) -> CoinModel? {
        let decoder = JSONDecoder()

        do {
            let decodedData = try decoder.decode(CoinJSON.self, from: data)

            let rate = decodedData.rate
            let currency = self.currency

            let coin = CoinModel(currency: currency, value: rate)

            return coin
        } catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
    }

}
