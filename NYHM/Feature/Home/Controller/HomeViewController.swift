//
//  HomeViewController.swift
//  NYHM
//
//  Created by Hafizh Mo on 12/06/22.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeView: HomeView!
    @IBOutlet weak var sortButton: UIBarButtonItem!
    
    private let repo = TranscriptionRepository.shared
    var transcriptions = [Transcriptions]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transcriptions = repo.showAll()
        homeView.setup(viewController: self)
        
        setupSorting()
        navigationItem.searchController = UISearchController()
    }
    
    private func setupSorting() {
        var menuItems: [UIAction] {
            return [
                UIAction(title: "Sort by name", image: UIImage(systemName: "character.bubble"), handler: { (_) in
                    //action here
                }),
                UIAction(title: "Sort by date", image: UIImage(systemName: "calendar.badge.clock"), handler: { (_) in
                    //action here
                }),
            ]
        }
        
        var demoMenu: UIMenu {
            return UIMenu(title: "Sort by", image: nil, identifier: nil, options: [], children: menuItems)
        }
        
        sortButton.menu = demoMenu
    }
    
}
