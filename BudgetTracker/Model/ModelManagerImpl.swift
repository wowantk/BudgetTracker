//
//  ModelManagerImpl.swift
//
import Foundation
import CoreData

public class ModelManagerImpl: ModelManager {
    
    private let coreDataManager: CoreDataManger
    private let networkManager: NetworManager
    
    public init(coreDataManager: CoreDataManger, networkManager: NetworManager) {
        self.coreDataManager = coreDataManager
        self.networkManager = networkManager
    }
    
    public var sections: Int {
        coreDataManager.fetchResultController.sections?.count ?? 0 
    }
    
    public func sectionsName(at section: Int) -> String {
        coreDataManager.fetchResultController.sections?[section].name ?? ""
    }
    
    public func countOfSections(at section: Int) -> Int {
        coreDataManager.fetchResultController.sections?[section].numberOfObjects ?? 0
    }
    
    public func getTransactions(at indexPath: IndexPath) -> Transaction? {
        coreDataManager.fetchResultController.object(at: indexPath)
    }
    
    public func addTransactions(transactionsType: TypeOfSpend, amount: Double) -> Result<Void, Error> {
        return coreDataManager.addTransactions(transactionsType: transactionsType, amount: amount)
    }
    
    public func performFetchTransactions() -> Result<Void, Error> {
        return coreDataManager.fetchTransactions()
    }
    
    public func fetchUser() -> Result<User, Error> {
        return coreDataManager.fetchUser()
    }
    
    public func setDelegate(delegate: NSFetchedResultsControllerDelegate) {
        coreDataManager.setDelegate(delegate: delegate)
    }

    public func saveContext() {
        coreDataManager.saveContext()
    }
    
    public func loadCurrency() async throws -> Currency {
        try await networkManager.loadItems()
    }

}
