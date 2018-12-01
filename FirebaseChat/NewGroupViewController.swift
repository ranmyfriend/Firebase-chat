//
//  NewGroupViewController.swift
//  FirebaseChat
//
//  Created by Ranjith Kumar on 11/27/18.
//  Copyright © 2018 DrawRect. All rights reserved.
//

import UIKit
import CoreData

class NewGroupViewController: UIViewController {
    
    var context: NSManagedObjectContext?
    var chatCreationDelegate: ChatCreationDelegate?
    
    private let subjectField = UITextField()
    private let characterNumberLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New Group"
        view.backgroundColor = UIColor.white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextPressed))
        
        updateNextButton(forCharCount: 0)
        
        subjectField.placeholder = "Group Subject"
        subjectField.delegate = self
        subjectField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subjectField)
        updateCharacterLabel(forCharCount: 0)
        
        characterNumberLabel.textColor = UIColor.gray
        characterNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(characterNumberLabel)
        
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = UIColor.lightGray
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        subjectField.addSubview(bottomBorder)
        
        let constraints: [NSLayoutConstraint] = [
            subjectField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            subjectField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            subjectField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBorder.widthAnchor.constraint(equalTo: subjectField.widthAnchor),
            bottomBorder.bottomAnchor.constraint(equalTo: subjectField.bottomAnchor),
            bottomBorder.leadingAnchor.constraint(equalTo: subjectField.leadingAnchor),
            bottomBorder.heightAnchor.constraint(equalToConstant: 1),
            characterNumberLabel.centerYAnchor.constraint(equalTo: subjectField.centerYAnchor),
            characterNumberLabel.trailingAnchor.constraint(equalTo: subjectField.layoutMarginsGuide.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    @objc func cancelPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func nextPressed() {
        guard let context = context, let chat = NSEntityDescription.insertNewObject(forEntityName: "Chat", into: context) as? Chat else {return}
        chat.name = subjectField.text
        
        let vc = NewGroupParticipantsViewController()
        vc.context = context
        vc.chat = chat
        vc.chatCreationDelegate = chatCreationDelegate
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateCharacterLabel(forCharCount length: Int) {
        characterNumberLabel.text = String(25 - length)
    }
    
    func updateNextButton(forCharCount length: Int) {
        if length == 0 {
            navigationItem.rightBarButtonItem?.tintColor = UIColor.lightGray
            navigationItem.rightBarButtonItem?.isEnabled = false
        }else {
            navigationItem.rightBarButtonItem?.tintColor = view.tintColor
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension NewGroupViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.count ?? 0
        let newLength = currentCharacterCount + string.count - range.length
        
        if newLength <= 25 {
            updateCharacterLabel(forCharCount: newLength)
            updateNextButton(forCharCount: newLength)
            return true
        }
        return false
    }
}
