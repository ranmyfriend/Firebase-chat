//
//  Message+CoreDataProperties.swift
//  FirebaseChat
//
//  Created by Ranjith Kumar on 10/21/18.
//  Copyright © 2018 DrawRect. All rights reserved.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var text: String?
    @NSManaged public var incoming: Bool
    @NSManaged public var timestamp: NSDate?
    @NSManaged public var chat: Chat?

}
