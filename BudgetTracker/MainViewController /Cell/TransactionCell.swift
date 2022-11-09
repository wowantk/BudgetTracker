//
//  TransactionCell.swift
//

import Foundation
import UIKit

internal final class TransactionCell: UITableViewCell {
    
    private let label: UILabel = makeLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(label)
        setLabelConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: Transaction) {
        label.text = "\(model.count), \(dateFormatter(time: model.time)) , \(model.type.rawValue)"
    }
    
    private func dateFormatter(time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "MMM d, yyyy"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: time)
    }
}

// MARK: - UIFabrick
private extension TransactionCell {
    
    private static func makeLabel() -> UILabel {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

}

// MARK: - ConstrainsFabric

private extension TransactionCell {
    
    private func setLabelConstrains() {
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
