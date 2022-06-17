//
//  HomeViewController+DataSource.swift
//  NYHM
//
//  Created by Hafizh Mo on 14/06/22.
//

import Foundation
import UIKit

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering {
            return filteredTranscriptions.count
        }
        return transcriptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemHomeCell", for: indexPath) as! ItemHomeCell
        
        var item:Transcriptions?
        if isFiltering {
            item = filteredTranscriptions[indexPath.section]
        }
        else {
            item = transcriptions[indexPath.section]
        }
        
        cell.titleLabel.text = item?.title!
        cell.tagsLabel.text = item?.tags!
        cell.createdAtLabel.text = item?.createdAt?.fixedFormat()
        cell.durationLabel.text = item?.duration!
        
        return cell
    }
    
    
}
