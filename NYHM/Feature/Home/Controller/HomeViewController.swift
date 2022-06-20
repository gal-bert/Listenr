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
    var filteredTranscriptions = [Transcriptions]()
    var currentSort = SortType.timeDesc
    
    let searchController = UISearchController()
    var searchBarIsEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isFirstTime = UserDefaults.standard.bool(forKey: Constants.IS_FIRST_TIME)
        if isFirstTime == true {
            TagsRepository.shared.add(name: "Lecture", position: 0)
            TagsRepository.shared.add(name: "Seminar", position: 1)
            TagsRepository.shared.add(name: "Conversation", position: 2)
            UserDefaults.standard.set(false, forKey: Constants.IS_FIRST_TIME)
        }
        
        transcriptions = repo.showAll()
        homeView.setup(viewController: self)
        
        searchController.searchBar.barStyle = .black
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        transcriptions = repo.showAll()
        homeView.tableView.reloadData()
    }
}
