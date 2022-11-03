//
//  MainViewController.swift
//

import UIKit

internal final class MainViewController: UIViewController, ContentControllerProtocol {

    typealias View = MainView

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.delegate = self
    }

    override func loadView() {
        self.view = View()
    }

}

//MARK: -MainViewDelegate

extension MainViewController: MainViewDelegate {

    func handleAddRefill(in view: MainView, updateView: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: "Add Bitcoin", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        let addAction = UIAlertAction(title: "Add", style: .default, handler: { [unowned alertController] _ in
            guard let text =  alertController.textFields?[0].text else {
                //TODO: show Error
                return
            }
            updateView(text)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        navigationController?.present(alertController, animated: true)
    }

    func handleAddTransactions(in view: MainView) {
        //TODO: -HandleTransaction
    }
    
    func handleError() { print("ERROR")}
}
