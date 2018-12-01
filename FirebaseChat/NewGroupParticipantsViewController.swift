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
        tableView.tableFooterView = UIView(frame: .zero)

        searchField = createSearchField()
        tableView.tableHeaderView = searchField

        fillViewWith(subView: tableView)
    }

    @objc private func createChat() {

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
