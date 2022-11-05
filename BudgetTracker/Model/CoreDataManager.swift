//
//  CoreDataManager.swift
//

import Foundation
import CoreData

public final class CoreDataManger {

    static let sharedManager = CoreDataManger()

    private var context: NSManagedObjectContext { persistentContainer.viewContext }

    private init() { }

    lazy var persistentContainer: NSPersistentContainer = {
          let container = NSPersistentContainer(name: "BudgetTracker")
          container.loadPersistentStores(completionHandler: { (_, error) in
              if let error = error as NSError? {
                  fatalError("Unresolved error \(error), \(error.userInfo)")
              }
          })
          return container
      }()

    func saveContext () {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }

    func addTransactions(transactionsType: TypeOfSpend, amount: Double) {
        let currentUserObject: UserObject?
        do {
            let fetchRequest =  UserObject.fetchRequest()
            currentUserObject = try context.fetch(fetchRequest).first
        } catch {
            print("Erro")
            return
        }
        let newTransactions = SpendingObject(context: self.context)
        newTransactions.count = amount
        newTransactions.time = Date()
        newTransactions.type = transactionsType
        switch transactionsType {
        case .earning: currentUserObject?.balance += amount
        default: currentUserObject?.balance -= amount
        }
        saveContext()
    }

//    func fetchTransactions() -> [Spending] {
//        let fetchRequest = NSFetchRequest<SpendingObject>(entityName: "SpendingObject")
//        fetchRequest.fetchLimit = 20
//        let sortByDate = NSSortDescriptor(key: #keyPath(SpendingObject.time), ascending: false)
//        do context.fetch(fetchRequest)
//    }

    func fetchUser() -> User {
        let userObject: UserObject
        let fetchRequest = UserObject.fetchRequest()
        do {
            userObject = try context.fetch(fetchRequest).first ?? UserObject(context: context)
            saveContext()
            return userObject
        } catch {
            print("ERROR")
            let user = UserObject(context: context)
            return user
        }
    }

}
