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
    func addNewTag(tagCount: Int, delegate: UIViewController) {
        print("tag count", tagCount)
        let alert = UIAlertController(title: "Add New Tag", message: nil, preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let textField = alert.textFields![0]
            TagsRepository.shared.add(name: textField.text ?? "", position: tagCount)
            
            if delegate is TagsModalViewController {
                (delegate as! TagsModalViewController).delegate!.tagSelected(tagName: textField.text!)
            }
            else if delegate is SettingsViewController {
                (delegate as! SettingsViewController).reloadData()
            }
            
            delegate.dismiss(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        addAction.isEnabled = false
        
        alert.overrideUserInterfaceStyle = .dark
        alert.view.tintColor = UIColor(red: 0.99, green: 0.82, blue: 0.15, alpha: 1.00)
        
        alert.addTextField { textField in
            textField.placeholder = "Enter tag name"
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using: {_ in
                let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                let textIsNotEmpty = textCount > 0
                addAction.isEnabled = textIsNotEmpty
                alert.textFields![1].text = "\(textCount) of 20 characters"
                
                if textCount > 20 {
                    textField.text?.removeLast()
                    alert.textFields![1].text = "20 of 20 characters"
                }
            })
        }
        alert.addTextField { textField in
            textField.text = "0 of 20 characters"
            textField.textAlignment = .center
            textField.isUserInteractionEnabled = false
        }
        
        if let textFields = alert.textFields {
            if textFields.count > 0 {
                textFields[1].superview!.superview!.subviews[0].removeFromSuperview()
                textFields[1].superview!.backgroundColor = UIColor.clear
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        present(alert, animated: true)
    }
}
