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
    
    let repo = TranscriptionRepository.shared
    var transcriptions = [Transcriptions]()
    var currentSort = SortType.timeDesc
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transcriptions = repo.showAll()
        homeView.setup(viewController: self)
        
        let searchController = UISearchController()
        searchController.searchBar.barStyle = .black
        navigationItem.searchController = searchController
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        transcriptions = repo.showAll()
        homeView.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toTranscriptionPageSegue" {
            if let dest = segue.destination as? TranscriptionViewController {
                dest.delegate = self
            }
        }
        
    }
    
    
    
}
