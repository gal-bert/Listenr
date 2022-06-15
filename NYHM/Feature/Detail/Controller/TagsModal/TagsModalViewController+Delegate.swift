//
//  TagsModalViewController+Delegate.swift
//  NYHM
//
//  Created by Karen Natalia on 15/06/22.
//

import Foundation
import UIKit

extension TagsModalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// TODO: Change selected tag in core data
        /// TODO: Trigger change the selected tag in detail
        dismiss(animated: true)
    }
}

extension TagsModalViewController: TagsModalDelegate {
    func addNewTag() {
        let alert = UIAlertController(title: "Add New Tag", message: nil, preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { action in
            // TODO: Put code to add new tag to core data here
        }
        
        alert.overrideUserInterfaceStyle = .dark
        alert.view.tintColor = UIColor(red: 0.99, green: 0.82, blue: 0.15, alpha: 1.00)
        alert.addTextField { textField in
            textField.placeholder = "Enter tag name"
        }
        alert.addAction(addAction)
        
        present(alert, animated: true)
    }
}
