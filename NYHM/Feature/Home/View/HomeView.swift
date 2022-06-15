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
    @IBOutlet weak var sortButton: UIBarButtonItem!
    
    private var delegate: HomeDelegate?
    
    lazy var castedDelegate = delegate as! HomeViewController
    
    func setup(viewController: HomeViewController) {
        delegate = viewController
        
        tableView.delegate = viewController
        tableView.dataSource = viewController
        tableView.registerCell(type: ItemHomeCell.self, identifier: "itemHomeCell")
        
        var menuItems: [UIAction] {
            return [
                UIAction(title: "Sort by name", image: UIImage(systemName: "character.bubble"), handler: { (_) in
                    self.delegate?.sortByName()
                }),
                UIAction(title: "Sort by date", image: UIImage(systemName: "calendar.badge.clock"), handler: { (_) in
                    self.delegate?.sortByDate()
                }),
            ]
        }
        
        sortButton.menu = UIMenu(title: "Sort by", image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    @IBAction func didTapLanguage(_ sender: UIButton) {
        delegate?.chooseLanguage()
    }
    
    
    @IBAction func transcribeButton(_ sender: Any) {
        castedDelegate.performSegue(withIdentifier: "toTranscriptionPageSegue", sender: self)
    }
    
}