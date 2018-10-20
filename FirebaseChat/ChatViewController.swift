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
    private var bottomConstraint: NSLayoutConstraint!
    
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
        sendButton.addTarget(self, action: #selector(pressedButton(button:)), for: .touchUpInside)
        sendButton.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        sendButton.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751), for: .horizontal)

        bottomConstraint = newMessageArea.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomConstraint.isActive = true

        let messageAreaConstraints: [NSLayoutConstraint] = [
            newMessageArea.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            newMessageArea.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),

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

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name(rawValue: "UIKeyboardWillShowNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name(rawValue: "UIKeyboardWillHideNotification"), object: nil)
        let tapRecoginzer = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(recoginzer:)))
        tapRecoginzer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapRecoginzer)
    }

    @objc func handleSingleTap(recoginzer: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @objc func keyboardWillShow(notification: Notification) {
        updateBottomConstraint(notification: notification)
    }

    @objc func keyboardWillHide(notification: Notification) {
        updateBottomConstraint(notification: notification)
    }

    func updateBottomConstraint(notification: Notification) {
        if let userInfo = notification.userInfo,
            let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double {
            let newFrame = view.convert(frame, from: (UIApplication.shared.delegate as! AppDelegate).window)
            bottomConstraint.constant = newFrame.origin.y - (view.frame).height
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func pressedButton(button: UIButton) {
        guard let text = newMessageField.text, text.count > 0 else {return}
        let message = Message()
        message.text = text
        message.incoming = false
        messages.append(message)
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: tableView.numberOfRows(inSection: 0)-1, section: 0), at: .bottom, animated: true)
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

