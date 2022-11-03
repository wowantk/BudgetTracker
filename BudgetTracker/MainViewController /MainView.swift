//
//  MainView.swift
//

import UIKit
import Foundation

internal protocol MainViewDelegate: AnyObject {
    func handleAddRefill(in view: MainView, updateView: @escaping (String) -> Void)
    func handleAddTransactions(in view: MainView)
    func handleError()
}

internal final class MainView: UIView {

    private let mainImage: UIImageView = makeImageView()
    private let balanceLabel: UILabel = makeLabel()
    private let addTransactions: UIButton = makeButton(buttonText: "Add Transactions")
    private let addRefill: UIButton = makeAddReffilbutton()

    weak var delegate: MainViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addAllSubviews()
        setAllConstrains()
        addTransactions.addTarget(self, action: #selector(handleAddTransactions), for: .touchUpInside)
        addRefill.addTarget(self, action: #selector(handleAddRefill), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func handleAddRefill() {
        delegate?.handleAddRefill(in: self, updateView: { [weak self] text in
            guard let self = self else { return }
            if self.isDecimalNumbers(text: text) {
                self.balanceLabel.text = text
            } else {
                self.delegate?.handleError()
            }
        })
    }

    @objc
    private func handleAddTransactions() {
        delegate?.handleAddTransactions(in: self)
    }

    private func isDecimalNumbers(text: String) -> Bool {
        text.range(
            of: "^[0-9.]*$",
            options: .regularExpression) != nil
    }
}

//MARK: -UIFactory
private extension MainView {

    private func addAllSubviews() {
        [mainImage, balanceLabel, addTransactions, addRefill]
            .forEach(addSubview(_:))
    }

    private static func makeImageView() -> UIImageView {
        let image = UIImage(named: "bitcoinLogo")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        label.backgroundColor = .red
        label.clipsToBounds = true
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

//MARK: -Constrains

private extension MainView {

    private func setAllConstrains() {
        setAddReffilConstrains()
        setLabelConstrains()
        setImageConstrains()
        setAddTransactionsButtonConstrains()
    }

    private func setImageConstrains() {
        mainImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        mainImage.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 50).isActive = true
        mainImage.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -50).isActive = true
        mainImage.bottomAnchor.constraint(equalTo: balanceLabel.topAnchor, constant: -20).isActive = true
    }

    private func setAddReffilConstrains() {
        addRefill.topAnchor.constraint(equalTo: mainImage.bottomAnchor, constant: 20).isActive = true
        addRefill.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        addRefill.heightAnchor.constraint(equalToConstant: 60).isActive = true
        addRefill.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }

    private func setLabelConstrains() {
        balanceLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
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

}
