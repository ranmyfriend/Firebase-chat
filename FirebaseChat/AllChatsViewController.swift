//
//  AllChatsViewController.swift
//  FirebaseChat
//
//  Created by Ranjith Kumar on 10/21/18.
//  Copyright © 2018 DrawRect. All rights reserved.
//

import UIKit
import CoreData

class AllChatsViewController: UIViewController,TableViewFetchedResultsDisplayer {

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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)

        let tableViewConstraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]

        NSLayoutConstraint.activate(tableViewConstraints)

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
    }

    @objc func newChat() {
        let newChatViewController = NewChatViewController()
        newChatViewController.context = context
        let navigationController = UINavigationController(rootViewController: newChatViewController)
        present(navigationController, animated: true, completion: nil)
    }

    func fakeData() {
        guard let context = context else {return}
        let chat = NSEntityDescription.insertNewObject(forEntityName: "Chat", into: context) as? Chat
    }

    func configureCell(cell: UITableViewCell,atIndexPath: IndexPath) {
        let cell = cell as! ChatCell
        guard let chat = fetchResultsController?.object(at: atIndexPath) as? Chat else { return }

        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YY"
        cell.nameLabel.text = "Eliot"
        cell.dateLabel.text = formatter.string(from: Date())
        cell.messageLabel.text = "Hey"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    }
}
