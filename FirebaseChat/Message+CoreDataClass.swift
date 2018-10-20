//
//  Message+CoreDataClass.swift
//  FirebaseChat
//
//  Created by Ranjith Kumar on 10/20/18.
//  Copyright © 2018 DrawRect. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Message)
public class Message: NSManagedObject {

    var isIncoming: Bool {
        get{
//            guard let incoming = incoming else { return false }
            return incoming
        }
        set(incoming){
            self.incoming = incoming
        }
    }

}
