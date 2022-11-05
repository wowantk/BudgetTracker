//
//  SpendingObject.swift
//

import Foundation
import CoreData

@objc(SpendingObject)
internal final class SpendingObject: NSManagedObject, Spending {

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
}
