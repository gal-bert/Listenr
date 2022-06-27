//
//  HomeViewController+Delegate.swift
//  NYHM
//
//  Created by Hafizh Mo on 14/06/22.
//

import Foundation
import UIKit
import FloatingPanel

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detail = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            if isFiltering {
                detail.transcription = filteredTranscriptions[indexPath.section]
            }
            else {
                detail.transcription = transcriptions[indexPath.section]
            }
            self.navigationController?.pushViewController(detail, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let alert = UIAlertController(title: "Delete Transcription?", message: "Are you sure to delete the selected transcription?", preferredStyle: .alert)

            alert.addAction(UIAlertAction(
                title: "Delete",
                style: .destructive,
                handler: { _ in
                    self.repo.delete(item: self.transcriptions[indexPath.section])
                    self.transcriptions = self.repo.showAll()
                    tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .left)
                    
                    if self.transcriptions.isEmpty
                    {
                        self.homeView.vertView.isHidden = false
                    }
                    else
                    {
                        self.homeView.vertView.isHidden = true
                    }

                }
            ))

            alert.addAction(UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: nil
            ))

            present(alert, animated: true)
            
            
        }
    }
    
}

extension HomeViewController: HomeDelegate {
    
    func chooseLanguage() {
        
        
        let sheet = UIAlertController(title: "Select Language", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Bahasa Indonesia", style: .default, handler: {_ in
            self.homeView.languageLabel.text = "Bahasa Indonesia"
            UserDefaults.standard.set("id", forKey: Constants.SELECTED_LANGUAGE)
            sheet.view.tintColor = UIColor (named: "actionPress")
            
             
        }))
        sheet.addAction(UIAlertAction(title: "English", style: .default, handler: {_ in
            self.homeView.languageLabel.text = "English"
            UserDefaults.standard.set("en-US", forKey: Constants.SELECTED_LANGUAGE)
        }))

        present(sheet, animated: true)
    }
    
    
    func sortBy(type: SortType) {
        transcriptions = repo.showAll(sortBy: type)
        currentSort = type
        
        homeView.generatePopOverMenu()
        reloadData()
    }
    
    private func reloadData() {
        var indexPathsToReload = [IndexPath]()
        
        for index in transcriptions.indices {
            let indexPath = IndexPath(row: 0, section: index)
            indexPathsToReload.append(indexPath)
        }
        homeView.tableView.reloadRows(at: indexPathsToReload, with: .middle)
        
        if transcriptions.isEmpty
        {
            homeView.vertView.isHidden = false
        }
        else
        {
        homeView.vertView.isHidden = true
        }

        
    }
    
    func showTranscriptionModal() {
        let modal = FloatingPanelController(delegate: self)
        let customLayout = TranscriptionModalLayout()
        modal.layout = customLayout
        
        let storyboard = UIStoryboard(name: "Transcription", bundle: nil)
        guard let transcriptionVC = storyboard.instantiateViewController(withIdentifier: "transcriptionVC") as? TranscriptionViewController else {return}
        
        transcriptionVC.delegate = self
        
        modal.set(contentViewController: transcriptionVC)
        
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 10.0
        modal.surfaceView.appearance = appearance

        self.present(modal, animated: true, completion: nil)
        
        
    }
    
}

extension HomeViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidChangeState(_ modal: FloatingPanelController) {
        let transcriptionVC = modal.contentViewController as? TranscriptionViewController
        
        if modal.state == .full {
            transcriptionVC?.stateDidChange(newState: 1)
        }
        else if modal.state == .half {
            transcriptionVC?.stateDidChange(newState: 2)
        }
    }
}

extension HomeViewController: SaveTranscriptionProtocol {
    func reloadTableView() {
        transcriptions = TranscriptionRepository.shared.showAll()
        homeView.tableView.reloadData()
        
        if transcriptions.isEmpty
        {
            homeView.vertView.isHidden = false
        }
        else
        {
        homeView.vertView.isHidden = true
        }

    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        searchBasedOnText(keyword: searchBar.text!)
        print("keyword: \(searchBar.text!)")
    }

    func searchBasedOnText(keyword: String) {
        filteredTranscriptions = transcriptions.filter({ transcription -> Bool in
            return transcription.title?.lowercased().contains(keyword.lowercased()) ?? false
        })
        homeView.tableView.reloadData()
    }
}
