//
//  ChatCreationDelegate.swift
//  FirebaseChat
//
//  Created by Ranjith Kumar on 11/26/18.
//  Copyright © 2018 DrawRect. All rights reserved.
//

import Foundation
import CoreData

protocol ChatCreationDelegate {
    func created(chat: Chat, inContext context: NSManagedObjectContext)
}
