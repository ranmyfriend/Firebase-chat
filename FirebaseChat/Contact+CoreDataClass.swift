//
//  Contact+CoreDataClass.swift
//  FirebaseChat
//
//  Created by Ranjith Kumar on 10/21/18.
//  Copyright © 2018 DrawRect. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Contact)
public class Contact: NSManagedObject {

    var sortLetter: String {
        let letter = lastName?.first ?? firstName?.first
        let s = String(letter!)
        return s
    }

    var fullName: String {
        var fullName = ""
        if let firstName = firstName {
            fullName += firstName
        }
        if let lastName = lastName {
            if fullName.count > 0 {
                fullName += ""
            }
            fullName += lastName
        }
        return fullName
    }
}
