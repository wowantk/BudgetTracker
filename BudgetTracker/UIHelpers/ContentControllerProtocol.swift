//
//  ContentControllerProtocol.swift
//

import UIKit

public protocol ContentControllerProtocol: AnyObject {
    
    associatedtype View: UIView
}

extension ContentControllerProtocol where Self: UIViewController {
    
    public var contentView: View {
        guard let contentView = view as? View else {
            fatalError("Screen initialized with wrong view class")
        }
        return contentView
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func showAlert(withMessage message:String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
}

extension String {
    var isNumber: Bool {
        return self.range(
            of: "^[0-9.]*$",
            options: .regularExpression) != nil
    }
}
