//
//  MainView.swift
//

import UIKit
import Foundation

internal protocol MainViewDelegate: AnyObject {
    func handleAddRefill(in view: MainView)
    func handleAddTransactions(in view: MainView)
    func handleSections() -> Int
    func handleNameAtSections(at section: Int) -> String
    func handleCountOfRowInSections(at section: Int) -> Int
    func handeCellForRowAt(at indexPath: IndexPath) -> Transaction?
}

internal final class MainView: UIView {

    private let currencyLabel: UILabel = makeLabel()
    private let balanceLabel: UILabel = makeLabel()
    private let addTransactions: UIButton = makeButton(buttonText: "Add Transactions")
    private let addRefill: UIButton = makeAddReffilbutton()
    let tableView: UITableView = makeTableView()

    weak var delegate: MainViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addAllSubviews()
        setAllConstrains()
        tableView.delegate = self
        tableView.dataSource = self
        addTransactions.addTarget(self, action: #selector(handleAddTransactions), for: .touchUpInside)
        addRefill.addTarget(self, action: #selector(handleAddRefill), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func handleAddRefill() {
        delegate?.handleAddRefill(in: self)
    }

    @objc
    private func handleAddTransactions() {
        delegate?.handleAddTransactions(in: self)
    }

    func update(user: User) {
        balanceLabel.text = "\(user.balance)"
    }
    
    func update(currency: Currency) {
        currencyLabel.text = "\(currency.rate)"
    }
}

// MARK: - TableViewDelegate
extension MainView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}

// MARK: - TableViewDataSource
extension MainView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return delegate?.handleSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return delegate?.handleNameAtSections(at: section) ?? ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.handleCountOfRowInSections(at: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(cell: TransactionCell.self, for: indexPath)
        guard let transaction: Transaction = delegate?.handeCellForRowAt(at: indexPath) else {
            return UITableViewCell()
        }
        cell.update(model: transaction)
        return cell
    }

}

// MARK: - UIFactory
private extension MainView {

    private func addAllSubviews() {
        [currencyLabel, balanceLabel, addTransactions, addRefill, tableView]
            .forEach(addSubview(_:))
    }

    private static func makeButton(buttonText: String) -> UIButton {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: buttonText), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
    }

    private static func makeAddReffilbutton() -> UIButton {
        let button = UIButton()
        let image = UIImage(named: "reffilImage")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    private static func makeLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.backgroundColor = .clear
        label.clipsToBounds = true
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private static func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.allowsSelection = false
        tableView.register(cell: TransactionCell.self)
        return tableView
    }
}

// MARK: - ConstrainsFactory
private extension MainView {

    private func setAllConstrains() {
        setCurrencyLabelConstrains()
        setAddReffilConstrains()
        setLabelConstrains()
        setAddTransactionsButtonConstrains()
        setTableViewConstrains()
    }

    private func setCurrencyLabelConstrains() {
        currencyLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        currencyLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        currencyLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
    }

    private func setAddReffilConstrains() {
        addRefill.topAnchor.constraint(equalTo: currencyLabel.bottomAnchor, constant: 5).isActive = true
        addRefill.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        addRefill.heightAnchor.constraint(equalToConstant: 60).isActive = true
        addRefill.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }

    private func setLabelConstrains() {
        balanceLabel.topAnchor.constraint(equalTo: currencyLabel.bottomAnchor, constant: 5).isActive = true
        balanceLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        balanceLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        balanceLabel.rightAnchor.constraint(equalTo: addRefill.leftAnchor, constant: -5).isActive = true
    }

    private func setAddTransactionsButtonConstrains() {
        addTransactions.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: 5).isActive = true
        addTransactions.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        addTransactions.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        addTransactions.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func setTableViewConstrains() {
        tableView.topAnchor.constraint(equalTo: addTransactions.bottomAnchor, constant: 5).isActive = true
        tableView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

}
