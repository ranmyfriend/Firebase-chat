//
//  ChatCell.swift
//  FirebaseChat
//
//  Created by Ranjith Kumar on 10/21/18.
//  Copyright © 2018 DrawRect. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    let nameLabel = UILabel()
    let messageLabel = UILabel()
    let dateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        messageLabel.textColor = UIColor.gray
        dateLabel.textColor = UIColor.gray

        let labels = [nameLabel,messageLabel,dateLabel]
        for label in labels {
            label.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(label)
        }

        let constraints: [NSLayoutConstraint] = [
            nameLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            dateLabel.firstBaselineAnchor.constraint(equalTo: nameLabel.firstBaselineAnchor)
        ]

        NSLayoutConstraint.activate(constraints)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
