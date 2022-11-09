//
//  ModelManager.swift
//

import Foundation
import CoreData

public protocol ModelManager {
    var sections: Int { get }
    func sectionsName(at section: Int) -> String
    func countOfSections(at section: Int) -> Int
    func getTransactions(at indexPath: IndexPath) -> Transaction?
    func fetchUser() -> Result<User, Error>
    func addTransactions(transactionsType: TypeOfSpend, amount: Double) -> Result<Void, Error>
    func performFetchTransactions() -> Result<Void, Error>
    func setDelegate(delegate: NSFetchedResultsControllerDelegate)
}
