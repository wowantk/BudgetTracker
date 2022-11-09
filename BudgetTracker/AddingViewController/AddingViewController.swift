//
//  AddingViewController.swift
//

import Foundation
import UIKit

public final class AddingViewController: UIViewController, ContentControllerProtocol {
    
    public typealias View = AddingContentView
    
    let modelManger: ModelManager
    
    init(modelManger: ModelManager) {
        self.modelManger = modelManger
        super.init(nibName: nil, bundle: nil)
        contentView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        self.view = View()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
}

extension AddingViewController:  AddingContentViewDelegate {
    
    func handleSaveButton(in view: AddingContentView, count: String?, type: String?) {
        guard let count = count, let type = type else {
            //TODO: Show Error
            return 
        }
        let typeOfSpend: TypeOfSpend = TypeOfSpend(rawValue: type) ?? .other
        let countSpend: Double = count.isNumber ? Double(count) ?? 0 : 0
        switch modelManger.addTransactions(transactionsType: typeOfSpend, amount: countSpend) {
        case .success(()): navigationController?.popViewController(animated: true)
        case .failure(let error): print("error")
        }
    }
    
    
}
