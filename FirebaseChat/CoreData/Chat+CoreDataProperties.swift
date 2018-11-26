//
//  Chat+CoreDataProperties.swift
//  FirebaseChat
//
//  Created by Ranjith Kumar on 11/26/18.
//  Copyright © 2018 DrawRect. All rights reserved.
//
//

import Foundation
import CoreData


extension Chat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chat> {
        return NSFetchRequest<Chat>(entityName: "Chat")
    }

    @NSManaged public var lastMessageTime: NSDate?
    @NSManaged public var messages: NSSet?
    @NSManaged public var participants: NSSet?

}

// MARK: Generated accessors for messages
extension Chat {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: Message)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: Message)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}

// MARK: Generated accessors for participants
extension Chat {

    @objc(addParticipantsObject:)
    @NSManaged public func addToParticipants(_ value: Contact)

    @objc(removeParticipantsObject:)
    @NSManaged public func removeFromParticipants(_ value: Contact)

    @objc(addParticipants:)
    @NSManaged public func addToParticipants(_ values: NSSet)

    @objc(removeParticipants:)
    @NSManaged public func removeFromParticipants(_ values: NSSet)

}
