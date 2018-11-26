//
//  UIViewController+FillWithView.swift
//  FirebaseChat
//
//  Created by Ranjith Kumar on 11/26/18.
//  Copyright © 2018 DrawRect. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func fillViewWith(subView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subView)
        
        let viewConstraints:[NSLayoutConstraint] = [
            subView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            subView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            subView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            subView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(viewConstraints)
    }
}
