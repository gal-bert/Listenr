//
//  HomeViewController+Delegate.swift
//  NYHM
//
//  Created by Hafizh Mo on 14/06/22.
//

import Foundation
import UIKit

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detail = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detail.transcription = transcriptions[indexPath.row]
            self.navigationController?.pushViewController(detail, animated: true)
        }
    }
}

extension HomeViewController: HomeDelegate {
    
    func chooseLanguage() {
        let sheet = UIAlertController(title: "Select Language", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Bahasa Indonesia", style: .default, handler: {_ in
            self.homeView.languageLabel.text = "Bahasa Indonesia"
            //TODO: set language transcription to Bahasa
        }))
        sheet.addAction(UIAlertAction(title: "English", style: .default, handler: {_ in
            self.homeView.languageLabel.text = "English"
            //TODO: set language transcription to English
        }))

        present(sheet, animated: true)
    }
    
    func sortByName() {
        if currentSort == SortType.alphabetAsc {
            transcriptions = repo.showAll(sortBy: .alphabetDesc)
            currentSort = .alphabetDesc
        } else {
            transcriptions = repo.showAll(sortBy: .alphabetAsc)
            currentSort = .alphabetAsc
        }
        
        reloadData()
    }
    
    func sortByDate() {
        if currentSort == SortType.timeAsc {
            transcriptions = repo.showAll(sortBy: .timeDesc)
            currentSort = .timeDesc
        } else {
            transcriptions = repo.showAll(sortBy: .timeAsc)
            currentSort = .timeAsc
        }
        
        reloadData()
    }
    
    private func reloadData() {
        var indexPathsToReload = [IndexPath]()
        
        for index in transcriptions.indices {
            let indexPath = IndexPath(row: index, section: 0)
            indexPathsToReload.append(indexPath)
        }
        
        homeView.tableView.reloadRows(at: indexPathsToReload, with: .middle)
    }
    
}
