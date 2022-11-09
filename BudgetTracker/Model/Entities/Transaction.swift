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
    case groceries = "Groceries"
    case taxi = "Taxi"
    case electronics = "Electronics"
    case restaurant = "Restaurant"
    case other = "Other"
    case earning =  "Earning"
}
