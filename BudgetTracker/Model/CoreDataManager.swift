//
//  CoreDataManager.swift
//

import Foundation
import CoreData

public final class CoreDataManger {

    private var context: NSManagedObjectContext { persistentContainer.viewContext }
    
    lazy var fetchResultController: NSFetchedResultsController<TransactionsObject> = createNSFetchResultController()

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

    func addTransactions(transactionsType: TypeOfSpend, amount: Double) -> Result<Void, Error> {
        let currentUserObject: UserObject?
        do {
            let fetchRequest =  UserObject.fetchRequest()
            currentUserObject = try context.fetch(fetchRequest).first
        } catch {
            return .failure(CoreDataError.addTransactionsError)
        }
        let newTransactions = TransactionsObject(context: self.context)
        newTransactions.count = amount
        newTransactions.time = Date()
        newTransactions.type = transactionsType
        switch transactionsType {
        case .earning: currentUserObject?.balance += amount
        default: currentUserObject?.balance -= amount
        }
        var arrayTransactions = currentUserObject?.spending ?? []
        arrayTransactions.append(newTransactions)
        currentUserObject?.pSpending = NSOrderedSet(array: arrayTransactions)
        saveContext()
        return .success(())
    }
    
    private func createNSFetchResultController() -> NSFetchedResultsController<TransactionsObject> {
        let nameSortDescriptor = NSSortDescriptor(key: "time", ascending: false)
        let fetch: NSFetchRequest<TransactionsObject> = NSFetchRequest<TransactionsObject>(entityName: "TransactionsObject")
        fetch.sortDescriptors = [nameSortDescriptor]
        return .init(fetchRequest: fetch, managedObjectContext: context, sectionNameKeyPath: #keyPath(TransactionsObject.dateDescription), cacheName: nil)
    }
    
    func fetchTransactions() -> Result<Void, Error> {
        do {
            try fetchResultController.performFetch()
            return .success(())
        } catch {
            return .failure(CoreDataError.performFetchError)
        }
        
    }
    
    

    func fetchUser() -> Result<User, Error> {
        let userObject: UserObject
        let fetchRequest = UserObject.fetchRequest()
        do {
            userObject = try context.fetch(fetchRequest).first ?? UserObject(context: context)
            saveContext()
            return .success(userObject)
        } catch {
            return .failure(CoreDataError.userFetchError)
        }
    }

}
