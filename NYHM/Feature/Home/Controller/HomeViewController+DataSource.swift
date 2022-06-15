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
        return transcriptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemHomeCell", for: indexPath) as! ItemHomeCell
        
        let item = transcriptions[indexPath.row]
        cell.titleLabel.text = item.title
        cell.tagsLabel.text = item.tags
        cell.createdAtLabel.text = item.createdAt?.fixedFormat()
        cell.durationLabel.text = item.duration
        
        return cell
    }
    
    
}
