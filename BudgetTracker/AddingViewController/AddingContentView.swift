//
//  AddingContentView.swift
//

import Foundation
import UIKit

internal protocol AddingContentViewDelegate: AnyObject {
    func handleSaveButton(in view: AddingContentView, count: String?, type: String?) //
}

public final class AddingContentView: UIView {
    
    private let pickerView: UIPickerView = makePicker()
    private let depositField: UITextField = makeLabel()
    private let typeOfTransactionsField: UITextField = makeLabel()
    private let buttonSave: UIButton = makeButton(buttonText: "Save")
    
    weak var delegate: AddingContentViewDelegate?
    
    private let typeOfTransactionsArrayString: [String] = [
        "Groceries",
        "Taxi",
        "Electronics",
        "Restaurant",
        "Other",
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        pickerView.delegate = self
        pickerView.dataSource = self
        typeOfTransactionsField.inputView = pickerView
        buttonSave.addTarget(self, action: #selector(handleSaveButton(sender:)), for: .touchUpInside)
        addAllSubview()
        setAllConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func handleSaveButton(sender: UIButton) {
        delegate?.handleSaveButton(in: self, count: depositField.text, type: typeOfTransactionsField.text)
    }
}

//MARK: -FabrickUI
private extension AddingContentView {
    
    private func addAllSubview() {
        [depositField, typeOfTransactionsField, buttonSave]
            .forEach({ addSubview($0) })
    }
    
    private static func makeLabel() -> UITextField {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.borderWidth = 1
        field.textAlignment = .center
        return field
    }
    
    private static func makePicker() -> UIPickerView {
        let pickerView = UIPickerView()
        return pickerView
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
}

//MARK: - PickerViewDelegate
extension AddingContentView: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typeOfTransactionsArrayString[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeOfTransactionsField.text = typeOfTransactionsArrayString[row]
        typeOfTransactionsField.resignFirstResponder()
    }
    
}

//MARK: - PickerViewDataSource
extension AddingContentView: UIPickerViewDataSource {
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeOfTransactionsArrayString.count
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
}

private extension AddingContentView {
    
    private func setAllConstrains() {
       setDepositField()
        setTypeOfTransactionsField()
        setButtonSave()
    }
    
    private func setDepositField() {
        let constrains = [
            depositField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            depositField.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 30),
            depositField.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -30),
            depositField.heightAnchor.constraint(equalToConstant: 40)
            ]
        NSLayoutConstraint.activate(constrains)
    }
    
    private func setTypeOfTransactionsField() {
        let constrains = [
            typeOfTransactionsField.topAnchor.constraint(equalTo: depositField.bottomAnchor, constant: 10),
            typeOfTransactionsField.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 30),
            typeOfTransactionsField.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -30),
            typeOfTransactionsField.heightAnchor.constraint(equalToConstant: 40)
        ]
        NSLayoutConstraint.activate(constrains)
        
    }
    
    private func setButtonSave() {
        let constrains = [
            buttonSave.topAnchor.constraint(equalTo: typeOfTransactionsField.bottomAnchor, constant: 10),
            buttonSave.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 30),
            buttonSave.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -30),
            buttonSave.heightAnchor.constraint(equalToConstant: 40)
        ]
        NSLayoutConstraint.activate(constrains)
    }
}
