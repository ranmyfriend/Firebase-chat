//
//  UITableView+Scroll.swift
//  FirebaseChat
//
//  Created by Ranjith Kumar on 10/20/18.
//  Copyright © 2018 DrawRect. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func scrollToBottom() {
        if numberOfSections > 1 {
            let lastSection = self.numberOfSections - 1
            self.scrollToRow(at: IndexPath(row: numberOfRows(inSection: lastSection)-1, section: lastSection), at: .bottom, animated: true)
        }else if numberOfRows(inSection: 0) > 0 && numberOfSections == 1{
            self.scrollToRow(at: IndexPath(row: self.numberOfRows(inSection: 0)-1, section: 0), at: .bottom, animated: true)
        }
    }
}
