//
//  Chat+CoreDataClass.swift
//  FirebaseChat
//
//  Created by Ranjith Kumar on 10/21/18.
//  Copyright © 2018 DrawRect. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Chat)
public class Chat: NSManagedObject {

    var lastMessage:Message? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Message")
        let predicate = NSPredicate(format: "chat = %@",self)
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key:"timestamp",ascending:false)]
        request.fetchLimit = 1
        do {
            guard let results = try self.managedObjectContext?.fetch(request) as? [Message] else { return nil }
            return results.first
        }catch {
            print("Error for Request")
        }
        return nil
    }
    
}
