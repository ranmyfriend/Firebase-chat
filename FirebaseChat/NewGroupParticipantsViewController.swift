//
//  NewGroupParticipantsViewController.swift
//  FirebaseChat
//
//  Created by Ranjith Kumar on 11/27/18.
//  Copyright © 2018 DrawRect. All rights reserved.
//

import UIKit
import CoreData

class NewGroupParticipantsViewController: UIViewController {

    var context: NSManagedObjectContext?
    var chat: Chat?
    var chatCreationDelegate: ChatCreationDelegate?

    private var searchField: UITextField!
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let cellIdentifier = "ContactCell"
    private var displayedContacts = [Contact]()

    private var allContacts = [Contact]()
    private var selectedContacts = [Contact]()
    private var isSearching:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add Participants"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(createChat))

        showCreateButton(show: false)

        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)

        searchField = createSearchField()
        searchField.delegate = self
        tableView.tableHeaderView = searchField

        fillViewWith(subView: tableView)

        if let context = context {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
            request.sortDescriptors = [
                NSSortDescriptor(key: "lastName", ascending: true),
                NSSortDescriptor(key: "firstName", ascending: true)]
            do {
                if let results = try context.fetch(request) as? [Contact] {
                    allContacts = results
                }
            }catch {
                print("There was a problem fetching.")
            }
        }
    }

    private func createSearchField() -> UITextField {
        let searchField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        searchField.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        searchField.placeholder = "Type contact name"

        let holderView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        searchField.leftView = holderView
        searchField.leftViewMode = .always
        let image = UIImage(named: "contact-icon")?.withRenderingMode(.alwaysTemplate)
        let contactImage = UIImageView(image: image)
        contactImage.tintColor = UIColor.darkGray

        holderView.addSubview(contactImage)
        contactImage.translatesAutoresizingMaskIntoConstraints = false

        let constraints:[NSLayoutConstraint] = [
            contactImage.widthAnchor.constraint(equalTo: holderView.widthAnchor,constant:-20),
            contactImage.heightAnchor.constraint(equalTo: holderView.heightAnchor,constant:-20),
            contactImage.centerXAnchor.constraint(equalTo: holderView.centerXAnchor),
            contactImage.centerYAnchor.constraint(equalTo: holderView.centerYAnchor)
        ]

        NSLayoutConstraint.activate(constraints)

        return searchField
    }

    private func showCreateButton(show:Bool) {
        if show {
            navigationItem.rightBarButtonItem?.tintColor = view.tintColor
            navigationItem.rightBarButtonItem?.isEnabled = true
        }else {
            navigationItem.rightBarButtonItem?.tintColor = UIColor.lightGray
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }

    private func endSearch() {
        displayedContacts = selectedContacts
        tableView.reloadData()
    }

   @objc func createChat() {
        guard let chat = chat, let context = context else{
            return
        }
        chat.participants = NSSet(array: selectedContacts)
        chatCreationDelegate?.created(chat: chat, inContext: context)
        dismiss(animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension NewGroupParticipantsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedContacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let contact = displayedContacts[indexPath.row]
        cell.textLabel?.text = contact.fullName
        cell.selectionStyle = .none
        return cell
    }
}

extension NewGroupParticipantsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = displayedContacts[indexPath.row]
        guard !selectedContacts.contains(contact)else{return}
        selectedContacts.append(contact)
        allContacts.remove(at: allContacts.index(where: {$0 === contact})!)
        searchField.text = ""
        endSearch()
        showCreateButton(show: true)
    }
}

extension NewGroupParticipantsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        isSearching = true
        guard let currentText = textField.text else {
            endSearch()
            return true
        }
        let text = NSString(string: currentText).replacingCharacters(in: range, with: string)
        if text.isEmpty == true {
            endSearch()
            return true
        }
        displayedContacts = allContacts.filter({ (contact) -> Bool in
            let match = contact.fullName.range(of: text) != nil
            return match
        })
        tableView.reloadData()
        return true
    }
}
