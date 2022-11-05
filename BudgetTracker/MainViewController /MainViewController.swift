//
//  MainViewController.swift
//

import UIKit

internal final class MainViewController: UIViewController, ContentControllerProtocol {

    typealias View = MainView

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.delegate = self
        update()
    }

    override func loadView() {
        self.view = View()
    }

    func update() {
        contentView.update(user: CoreDataManger.sharedManager.fetchUser())
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
            CoreDataManger.sharedManager.addTransactions(transactionsType: .earning, amount: Double(text) ?? 0)
            self?.update()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        navigationController?.present(alertController, animated: true)
    }

    func handleAddTransactions(in view: MainView) {
        // TODO: - HandleTransaction
    }

    func handleError() { print("ERROR")}
}
