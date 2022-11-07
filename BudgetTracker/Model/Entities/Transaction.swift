//
//  Spending.swift
//

import Foundation

public protocol Transaction {
    var type: TypeOfSpend { get }
    var time: Date { get }
    var count: Double { get }
}

public enum TypeOfSpend: String {
    case groceries
    case taxi
    case electronics
    case restaurant
    case other
    case earning
}
