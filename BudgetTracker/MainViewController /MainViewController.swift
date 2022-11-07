//
//  MainViewController.swift
//

import UIKit

internal final class MainViewController: UIViewController, ContentControllerProtocol {

    typealias View = MainView
    
    private let modelManager: ModelManager = ModelManagerImpl()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        switch modelManager.performFetchTransactions() {
        case .success(()): break
        case .failure(let error): print(error)
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.delegate = self
        update()
    }

    override func loadView() {
        self.view = View()
    }

    func update() {
        switch modelManager.fetchUser() {
        case.success(let user): contentView.update(user: user)
        case .failure(let error): print(error)
        }
        
    }

}

// MARK: - MainViewDelegate

extension MainViewController: MainViewDelegate {

    func handleAddRefill(in view: MainView, updateView: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: "Add Bitcoin", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        let addAction = UIAlertAction(title: "Add", style: .default, handler: { [unowned alertController, weak self] _ in
            guard let text =  alertController.textFields?[0].text else {
                // TODO: - show Error
                return
            }
            switch self?.modelManager.addTransactions(transactionsType: .earning, amount: Double(text) ?? 0) {
            case .success(()): self?.update()
            case .failure(let error): print(error)
            case .none: break
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        navigationController?.present(alertController, animated: true)
    }

    func handleAddTransactions(in view: MainView) {
        // TODO: - HandleTransaction
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

    func handleError() { print("ERROR")}
}
