//
//  AllChatsViewController.swift
//  FirebaseChat
//
//  Created by Ranjith Kumar on 10/21/18.
//  Copyright © 2018 DrawRect. All rights reserved.
//

import UIKit
import CoreData

class AllChatsViewController: UIViewController,TableViewFetchedResultsDisplayer,ChatCreationDelegate {

    var context: NSManagedObjectContext?
    private var fetchResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let cellIdentifier = "MessageCell"
    
    private var fetchResultsDelegate: NSFetchedResultsControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Chats"

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "newChat"), style: .plain, target: self, action: #selector(newChat))

        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }

        tableView.register(ChatCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableHeaderView = createHeader()
        tableView.dataSource = self
        tableView.delegate = self
        fillViewWith(subView: tableView)

        if let context = context {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Chat")
            request.sortDescriptors = [NSSortDescriptor(key: "lastMessageTime", ascending: false)]
            fetchResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsDelegate = TableViewFetchResultsDelegate(tableView: tableView, displayer: self)
            fetchResultsController?.delegate = fetchResultsDelegate
            do {
                try fetchResultsController?.performFetch()
            }catch {
                print("There was a problem fetching")
            }
        }
        fakeData()
    }

    @objc func newChat() {
        let newChatViewController = NewChatViewController()
        let chatContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        chatContext.parent = context
        newChatViewController.context = chatContext
        newChatViewController.chatCreationDelegate = self
        let navigationController = UINavigationController(rootViewController: newChatViewController)
        present(navigationController, animated: true, completion: nil)
    }

    func fakeData() {
        guard let context = context else {return}
        let chat = NSEntityDescription.insertNewObject(forEntityName: "Chat", into: context) as? Chat
        do {
            try context.save()
        }catch {
            print("Error Saving")
        }
    }

    func configureCell(cell: UITableViewCell,atIndexPath: IndexPath) {
        let cell = cell as! ChatCell
        guard let chat = fetchResultsController?.object(at: atIndexPath) as? Chat else { return }
        guard let contact = chat.participants?.anyObject() as? Contact else {return}
        guard let lastMessage = chat.lastMessage,
              let timestamp = lastMessage.timestamp,
              let txt = lastMessage.text else {return}

        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YY"
        cell.nameLabel.text = contact.fullName
        cell.dateLabel.text = formatter.string(from: timestamp as Date)
        cell.messageLabel.text = txt
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func created(chat: Chat, inContext context: NSManagedObjectContext) {
        let vc = ChatViewController()
        vc.context = context
        vc.chat = chat
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func createHeader() -> UIView {
        let header = UIView()
        let newGroupButton = UIButton()
        newGroupButton.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(newGroupButton)
        
        newGroupButton.setTitle("New Group", for: .normal)
        newGroupButton.setTitleColor(view.tintColor, for: .normal)
        newGroupButton.addTarget(self, action: #selector(pressedNewGroup), for: .touchUpInside)
        
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(border)
        
        border.backgroundColor = UIColor.lightGray
        
        let constraints: [NSLayoutConstraint] = [
            newGroupButton.heightAnchor.constraint(equalTo: header.heightAnchor),
            newGroupButton.trailingAnchor.constraint(equalTo: header.layoutMarginsGuide.trailingAnchor),
            border.heightAnchor.constraint(equalToConstant: 1),
            border.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            border.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            border.bottomAnchor.constraint(equalTo: header.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        header.setNeedsLayout()
        header.layoutIfNeeded()
        let height = header.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        var frame = header.frame
        frame.size.height = height
        header.frame = frame
        
        return header
    }
    
    @objc func pressedNewGroup() {
        let newGroupVC = NewGroupViewController()
        let chatContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        chatContext.parent = context
        newGroupVC.context = chatContext
        newGroupVC.chatCreationDelegate = self
        let nc = UINavigationController(rootViewController: newGroupVC)
        present(nc, animated: true, completion: nil)
    }

}

extension AllChatsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResultsController?.sections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchResultsController?.sections else {return 0}
        let currentSection = sections[section]
        return currentSection.numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        configureCell(cell: cell, atIndexPath: indexPath)
        return cell
    }
}

extension AllChatsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let chat = fetchResultsController?.object(at: indexPath) as? Chat else {return}
        let chatVC = ChatViewController()
        chatVC.context = context
        chatVC.chat = chat
        navigationController?.pushViewController(chatVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

