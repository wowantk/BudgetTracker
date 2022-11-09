//
//  MainViewController.swift
//

import UIKit
import CoreData

internal final class MainViewController: UIViewController, ContentControllerProtocol {

    typealias View = MainView
    
    private let modelManager: ModelManager
    
    init(modelManager: ModelManager) {
        self.modelManager = modelManager
        super.init(nibName: nil, bundle: nil)
        setupHandlerBackground()
        modelManager.setDelegate(delegate: self)
        switch modelManager.performFetchTransactions() {
        case .success(()): break
        case .failure(let error): showAlert(withMessage: error.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        update()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.delegate = self
    }

    override func loadView() {
        self.view = View()
    }

    func update() {
        switch modelManager.fetchUser() {
        case.success(let user):
            contentView.update(user: user)
        case .failure(let error): showAlert(withMessage: error.localizedDescription)
        }
    }
    
    @objc
    private func loadCurrency() {
        Task {
            do {
                let currency = try await modelManager.loadCurrency()
                contentView.update(currency: currency)
            } catch {
                showAlert(withMessage: error.localizedDescription)
            }
        }
    }
    
    private func setupHandlerBackground() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadCurrency) , name:  UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    private func addTransactions(transactionsType: TypeOfSpend = .earning, amount: String) {
        switch self.modelManager.addTransactions(transactionsType: .earning, amount: Double(amount) ?? 0) {
        case .success(()): update()
        case .failure(let error): showAlert(withMessage: error.localizedDescription)
        }
    }

}

// MARK: - NSFetchResultControllerDelegate
// TODO: - Create Observer Manager for incapsulate logick of frc(Massive View Controller)

extension MainViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        contentView.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert: contentView.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete: contentView.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default: return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                contentView.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                guard let transactions = modelManager.getTransactions(at: indexPath) else { break }
                guard let cell = contentView.tableView.cellForRow(at: indexPath) as? TransactionCell else { break }
                cell.update(model: transactions)
            }
        case .move:
            if let indexPath = indexPath {
                contentView.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                contentView.tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                contentView.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        contentView.tableView.endUpdates()
    }
}


// MARK: - MainViewDelegate

extension MainViewController: MainViewDelegate {

    func handleAddRefill(in view: MainView) {
        let alertController = UIAlertController(title: "Add Bitcoin", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        alertController.textFields?[0].keyboardType = .numbersAndPunctuation
        let addAction = UIAlertAction(title: "Add", style: .default, handler: { [unowned alertController, weak self] _ in
            guard let text =  alertController.textFields?[0].text, text.isNumber else {
                self?.showAlert(withMessage: "Please write only number")
                return
            }
            self?.addTransactions(amount: text)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        navigationController?.present(alertController, animated: true)
    }

    func handleAddTransactions(in view: MainView) {
        navigationController?.pushViewController(AddingViewController(modelManger: modelManager), animated: true)
    }
    
    func handleSections() -> Int {
        modelManager.sections
    }
    
    func handleNameAtSections(at section: Int) -> String {
        modelManager.sectionsName(at: section)
    }
    
    func handleCountOfRowInSections(at section: Int) -> Int {
         modelManager.countOfSections(at: section)
    }
    
    func handeCellForRowAt(at indexPath: IndexPath) -> Transaction? {
         modelManager.getTransactions(at: indexPath)
    }
}
