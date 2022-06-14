//
//  HomeView.swift
//  NYHM
//
//  Created by Hafizh Mo on 14/06/22.
//

import Foundation
import UIKit

class HomeView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var viewController: HomeViewController?
    
    func setup(viewController: HomeViewController) {
        self.viewController = viewController
        tableView.delegate = viewController
        tableView.dataSource = viewController
        
        tableView.registerCell(type: ItemHomeCell.self, identifier: "itemHomeCell")
    }
    
    @IBAction func didTapLanguage(_ sender: UIButton) {
        let sheet = UIAlertController(title: "Select Language", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Bahasa Indonesia", style: .default, handler: {_ in

        }))
        sheet.addAction(UIAlertAction(title: "English", style: .default, handler: {_ in

        }))

        viewController?.present(sheet, animated: true)
    }
}
