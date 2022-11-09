//
//  CurrencyDecodableObject.swift
//

import Foundation

// MARK: - Welcome
internal struct CurrencyDecodableObject: Codable {
    let bpi: Bpi
}

// MARK: - Bpi
internal struct Bpi: Codable {
    let usd: USD

    enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}

// MARK: - USD
internal struct USD: Codable {
    let rate: String
    let rateFloat: Double

    enum CodingKeys: String, CodingKey {
        case rate
        case rateFloat = "rate_float"
    }
}
