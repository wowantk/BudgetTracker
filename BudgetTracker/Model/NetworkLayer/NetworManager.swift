//
//  NetworManager.swift
//

import Foundation

public protocol NetworManager {
    func loadItems() async throws -> Currency
}
