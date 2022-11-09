//
//  CurrencyDecodableObject.swift
//

import Foundation

internal struct CurrencyDecodableObject: Codable {
    let bpi: Bpi
}

internal struct Bpi: Codable {
    let usd: USD

    enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}

internal struct USD: Codable {
    let rate: String
    let rateFloat: Double

    enum CodingKeys: String, CodingKey {
        case rate
        case rateFloat = "rate_float"
    }
}
