//
//  NewChatViewController.swift
//  FirebaseChat
//
//  Created by Ranjith Kumar on 11/25/18.
//  Copyright © 2018 DrawRect. All rights reserved.
//

import UIKit
import CoreData

class NewChatViewController: UIViewController,TableViewFetchedResultsDisplayer {
    
    var context: NSManagedObjectContext?
    private var fetchResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let cellIdentifier = "ContactCell"
    private var fetchResultsDelegate: NSFetchedResultsControllerDelegate?
    var chatCreationDelegate: ChatCreationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New Chat"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        fillViewWith(subView: tableView)
        
        if let context = context {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
            request.sortDescriptors = [
                NSSortDescriptor(key: "lastName", ascending: true),
                NSSortDescriptor(key: "firstName", ascending: true)]
            
            fetchResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "sortLetter", cacheName: "NewChatViewController")
            
            fetchResultsDelegate = TableViewFetchResultsDelegate(tableView: tableView, displayer: self)
            fetchResultsController?.delegate = fetchResultsDelegate
            
            do {
                try fetchResultsController?.performFetch()
            }catch {
                print("There was a problem fetching.")
            }
            
        }
        
    }
    @objc func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    
    func configureCell(cell: UITableViewCell, atIndexPath: IndexPath) {
        guard let contact = fetchResultsController?.object(at: atIndexPath) as? Contact else { return }
        cell.textLabel?.text = contact.fullName
    }
    
   
}

extension NewChatViewController: UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = fetchResultsController?.sections else {return nil}
        let currentSection = sections[section]
        return currentSection.name
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension NewChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let contact = fetchResultsController?.object(at: indexPath) as? Contact else {return}
        guard let context = context else {return}
        guard let chat = NSEntityDescription.insertNewObject(forEntityName: "Chat", into: context) as? Chat else {return}
        chat.add(participant: contact)
        chatCreationDelegate?.created(chat: chat, inContext: context)
        dismiss(animated: true, completion: nil)
    }
}

