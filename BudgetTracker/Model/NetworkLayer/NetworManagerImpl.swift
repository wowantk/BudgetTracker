//
//  NetworManagerImpl.swift
//

import Foundation

internal final class NetworManagerImpl: NetworManager {
    
    private var session = URLSession.shared

    func loadItems() async throws -> Currency {
        let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json")
        guard let url = url else {
            throw NetworkError.badUrl
        }
        let urlRequest = URLRequest(url: url)
        let (data, _) = try await session.data(for: urlRequest)
        let decoder = JSONDecoder()
        let currency = try decoder.decode(CurrencyDecodableObject.self, from: data)
        return Currency(rate: currency.bpi.usd.rateFloat)
    }
    
}

public enum NetworkError: LocalizedError {
    case badUrl
    
    public var errorDescription: String? {
        switch self {
        case .badUrl: return "You have entered bad URL"
        }
    }
}
