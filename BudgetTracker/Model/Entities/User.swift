//
//  User.swift
//

import Foundation

public protocol User {
    var balance: Double { get }
    var spending: [Transaction] { get }
}
