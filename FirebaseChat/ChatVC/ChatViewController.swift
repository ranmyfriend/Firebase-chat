//
//  ViewController.swift
//  FirebaseChat
//
//  Created by Ranjith Kumar on 10/16/18.
//  Copyright © 2018 DrawRect. All rights reserved.
//

import UIKit
import CoreData

class ChatViewController: UIViewController {

    private let tableView =  UITableView(frame: .zero, style: .grouped)
    private let newMessageField = UITextView()
    private var sections = [Date : [Message]]()
    private var dates = [Date]()
    private let cellIdentifier = "Cell"
    private var bottomConstraint: NSLayoutConstraint!

    var context: NSManagedObjectContext?
    var chat: Chat?
    
    private enum error: Error {
        case NoChat
        case NoContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            guard let chat = chat else {throw error.NoChat}
            guard let context = context else {throw error.NoContext}
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
            request.predicate = NSPredicate(format: "chat=%@", chat)
            request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
            if let result = try context.fetch(request) as? [Message] {
                for message in result {
                    addMessage(message: message)
                }
              dates.sort{($0 as NSDate).earlierDate($1) == $0}
            }
        }catch {
            print("We couldn't fetch!!!")
        }
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
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
        
        tableView.register(MessageCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 44
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "MessageBubble"))
        tableView.separatorColor = UIColor.clear
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 25
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        let tableViewConstraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.scrollToBottom()
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
            tableView.scrollToBottom()
        }
    }

    @objc func pressedButton(button: UIButton) {
        guard let text = newMessageField.text, text.count > 0 else {return}
        guard let context = context else { return }
        guard let message = NSEntityDescription.insertNewObject(forEntityName: "Message",into:context) as? Message else {return}
        message.text = text
        message.timestamp = Date() as NSDate
        message.chat = chat
        chat?.lastMessageTime = message.timestamp
        do {
            try context.save()
        }catch {
            print("There was a problem saving:\(error)")
            return
        }
        newMessageField.text = ""
        tableView.reloadData()
        tableView.scrollToBottom()
        view.endEditing(true)
    }

    func addMessage(message: Message) {
        guard let date = message.timestamp else {return}
        let calendar = NSCalendar.current
        let startDay = calendar.startOfDay(for: date as Date)

        var messages = sections[startDay]
        if messages == nil {
            dates.append(startDay)
            dates.sort{($0 as NSDate).earlierDate($1) == $0}
            messages = [Message]()
        }
        messages!.append(message)
        messages!.sort{($0.timestamp!.earlierDate($1.timestamp! as Date)) == $0.timestamp! as Date}
        sections[startDay] = messages
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension ChatViewController: UITableViewDataSource {

    func getMessages(section: Int) ->[Message] {
        let date = dates[section]
        return sections[date]!
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getMessages(section: section).count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MessageCell else {fatalError()}
        let messages = getMessages(section: indexPath.section)
        let message = messages[indexPath.row]
        cell.messageLabel.text = message.text
        cell.incoming(message.isIncoming)
        cell.separatorInset = UIEdgeInsets.init(top: 0, left: tableView.bounds.size.width, bottom: 0, right: 0)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        let paddingView = UIView()
        view.addSubview(paddingView)
        paddingView.translatesAutoresizingMaskIntoConstraints = false
        let dateLabel = UILabel()
        paddingView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        let constraints: [NSLayoutConstraint] = [

            paddingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            paddingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dateLabel.centerXAnchor.constraint(equalTo: paddingView.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: paddingView.centerYAnchor),
            paddingView.heightAnchor.constraint(equalTo: dateLabel.heightAnchor, constant: 5),
            paddingView.widthAnchor.constraint(equalTo: dateLabel.widthAnchor, constant:10),
            view.heightAnchor.constraint(equalTo: paddingView.heightAnchor)
        ]

        NSLayoutConstraint.activate(constraints)

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, YYYY"
        dateLabel.text = formatter.string(from: dates[section])
        paddingView.layer.cornerRadius = 10
        paddingView.layer.masksToBounds = true
        paddingView.backgroundColor = UIColor(red: 153/255, green: 204/255, blue: 255/255, alpha: 1.0)
        return view
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

