//
//  Alert+Ext.swift
//  NYHM
//
//  Created by Hafizh Mo on 15/06/22.
//

import Foundation
import UIKit
import SwiftUI

extension UIViewController {
    func addNewTag(tagCount: Int, delegate: TagsModalViewController) {
        let alert = UIAlertController(title: "Add New Tag", message: nil, preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let textField = alert.textFields![0]
            TagsRepository.shared.add(name: textField.text ?? "", position: tagCount)
            delegate.delegate!.tagSelected(tagName: textField.text!)
            delegate.dismiss(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        addAction.isEnabled = false
        
        alert.overrideUserInterfaceStyle = .dark
        alert.view.tintColor = UIColor(red: 0.99, green: 0.82, blue: 0.15, alpha: 1.00)
        alert.addTextField { textField in
            textField.placeholder = "Enter tag name"
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using:
                                                    {_ in
                let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                let textIsNotEmpty = textCount > 0
                
                addAction.isEnabled = textIsNotEmpty
            })
        }
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        present(alert, animated: true)
    }
}
