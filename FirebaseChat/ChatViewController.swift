//
//  ViewController.swift
//  FirebaseChat
//
//  Created by Ranjith Kumar on 10/16/18.
//  Copyright © 2018 DrawRect. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    private let tableView =  UITableView()
    private let newMessageField = UITextView()
    private var messages = [Message]()
    private let cellIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chats"
        
        var localIncoming = true
        
        for i in 0...10 {
            let m = Message()
//            m.text = String(i)
            m.text = "This is Longer Text. Do you like this?"
            m.incoming = localIncoming
            localIncoming = !localIncoming
            messages.append(m)
        }

        let newMessageArea = UIView()
        newMessageArea.backgroundColor = UIColor.lightGray
        newMessageArea.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newMessageArea)

        newMessageField.translatesAutoresizingMaskIntoConstraints = false
        newMessageArea.addSubview(newMessageField)
        newMessageField.isScrollEnabled = false

        let sendButton = UIButton()
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        newMessageArea.addSubview(sendButton)
        sendButton.setTitle("Send", for: .normal)
        sendButton.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)

        let messageAreaConstraints: [NSLayoutConstraint] = [
            newMessageArea.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            newMessageArea.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            newMessageArea.bottomAnchor.constraint(
                equalTo: view.bottomAnchor),

            newMessageField.leadingAnchor.constraint(
                equalTo: newMessageArea.leadingAnchor,constant: 10),
            newMessageField.centerYAnchor.constraint(
                equalTo: newMessageArea.centerYAnchor),

            sendButton.trailingAnchor.constraint(
                equalTo: newMessageArea.trailingAnchor,constant: -10),
            newMessageField.trailingAnchor.constraint(
                equalTo: sendButton.leadingAnchor, constant: -10),
            sendButton.centerYAnchor.constraint(
                equalTo: newMessageField.centerYAnchor),
            newMessageArea.heightAnchor.constraint(
                equalTo: newMessageField.heightAnchor, constant: 20)
        ]
        NSLayoutConstraint.activate(messageAreaConstraints)
        
        tableView.register(ChatCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 44
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        let tableViewConstraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: newMessageArea.topAnchor),
        ]
        NSLayoutConstraint.activate(tableViewConstraints)
    }
  
}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ChatCell else {fatalError()}
        let message = messages[indexPath.row]
        cell.messageLabel.text = message.text
        cell.incoming(message.incoming)
        cell.separatorInset = UIEdgeInsetsMake(0, tableView.bounds.size.width, 0, 0)
        return cell
    }
    
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

