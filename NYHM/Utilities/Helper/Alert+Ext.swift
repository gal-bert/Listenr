//
//  Alert+Ext.swift
//  NYHM
//
//  Created by Hafizh Mo on 15/06/22.
//

import Foundation
import UIKit

extension UIViewController {
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
