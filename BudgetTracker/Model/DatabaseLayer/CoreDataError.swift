//
//  CoreDataError.swift
//

import Foundation
import UIKit

public enum CoreDataError: LocalizedError {
    case userFetchError
    case transactionFetchError
    case addTransactionsError
    case performFetchError
    
    public var errorDescription: String? {
        switch self {
        case .addTransactionsError: return "Failed adding transactions"
        case .transactionFetchError: return "Failed transactions fetch error"
        case .userFetchError: return "Failed fetch error"
        case .performFetchError: return "Failed fetch error"
        }
    }
}
