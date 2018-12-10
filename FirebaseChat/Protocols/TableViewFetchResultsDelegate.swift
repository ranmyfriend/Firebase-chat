//
//  TableViewFetchResultsDelegate.swift
//  FirebaseChat
//
//  Created by Ranjith Kumar on 11/26/18.
//  Copyright © 2018 DrawRect. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TableViewFetchResultsDelegate: NSObject, NSFetchedResultsControllerDelegate {
    
    private var tableView: UITableView!
    private var displayer: TableViewFetchedResultsDisplayer!
    
    init(tableView:UITableView,displayer:TableViewFetchedResultsDisplayer) {
        self.tableView = tableView
        self.displayer = displayer
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default: break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .update:
            let cell = tableView.cellForRow(at: indexPath!)
            self.displayer.configureCell(cell: cell!, atIndexPath: indexPath!)
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}

protocol TableViewFetchedResultsDisplayer {
    func configureCell(cell: UITableViewCell, atIndexPath: IndexPath)
}
