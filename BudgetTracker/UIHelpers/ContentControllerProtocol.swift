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
