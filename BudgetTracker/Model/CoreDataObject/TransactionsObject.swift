//
//  SpendingObject.swift
//

import Foundation
import CoreData

@objc(TransactionsObject)
internal final class TransactionsObject: NSManagedObject, Transaction {

    var type: TypeOfSpend {
        get { TypeOfSpend(rawValue: pType) ?? .other }
        set { pType = newValue.rawValue}
    }

    @NSManaged
    var time: Date

    @NSManaged
    var count: Double

    @NSManaged
    private var pType: String
    
    @objc
    var dateDescription: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.timeZone = TimeZone(identifier: "GMT")
        return formatter.string(from: time)
    }
}
