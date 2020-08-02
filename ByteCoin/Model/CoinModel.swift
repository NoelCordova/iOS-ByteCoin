//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Noel Espino Córdova on 02/08/20.
//  Copyright © 2020 slingercode. All rights reserved.
//

import Foundation

struct CoinModel {

    let currency: String
    let value: Double

    var valueString: String {
        return String(format: "%.2f", value)
    }

}
