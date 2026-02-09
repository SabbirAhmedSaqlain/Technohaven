//
//  TransactionCell.swift
//  TestExam
//
//  Created by Sabbir on 2/8/26.
//

import UIKit

final class TransactionCell: UITableViewCell {
    static let reuseId = "TransactionCell"

    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let amountLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupUI() {
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        dateLabel.font = .systemFont(ofSize: 13, weight: .regular)
        dateLabel.textColor = .secondaryLabel
        amountLabel.font = .systemFont(ofSize: 16, weight: .bold)
        amountLabel.textAlignment = .right

        let leftStack = UIStackView(arrangedSubviews: [titleLabel, dateLabel])
        leftStack.axis = .vertical
        leftStack.spacing = 4

        let root = UIStackView(arrangedSubviews: [leftStack, amountLabel])
        root.axis = .horizontal
        root.spacing = 12
        root.alignment = .center
        root.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(root)
        NSLayoutConstraint.activate([
            root.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            root.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            root.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            root.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])

        amountLabel.setContentHuggingPriority(.required, for: .horizontal)
    }

    func configure(title: String, date: String, amount: String, isPositive: Bool) {
        titleLabel.text = title
        dateLabel.text = date
        amountLabel.text = amount
        amountLabel.textColor = isPositive ? .systemGreen : .systemRed
    }
}
