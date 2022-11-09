//
//  UserObject.swift
//

import Foundation
import CoreData

@objc(UserObject)
internal final class UserObject: NSManagedObject, User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserObject> {
           return NSFetchRequest<UserObject>(entityName: "UserObject")
       }

    @NSManaged
    var balance: Double

    var spending: [Transaction] { pSpending.array as? [Transaction] ?? [] }

    @NSManaged
    var pSpending: NSOrderedSet

}
