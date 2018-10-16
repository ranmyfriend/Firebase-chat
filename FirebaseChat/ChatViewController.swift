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
    private var messages = [Message]()
    private let cellIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var localIncoming = true
        
        for i in 0...10 {
            let m = Message()
//            m.text = String(i)
            m.text = "This is Longer Text."
            m.incoming = localIncoming
            localIncoming = !localIncoming
            messages.append(m)
        }
        
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
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
        return cell
    }
    
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

