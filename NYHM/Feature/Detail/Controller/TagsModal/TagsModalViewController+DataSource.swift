//
//  TagsModalViewController+DataSource.swift
//  NYHM
//
//  Created by Karen Natalia on 15/06/22.
//

import Foundation
import UIKit

extension TagsModalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tagList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath)
        
        var cellContent = cell.defaultContentConfiguration()
        cellContent.textProperties.color = .white
        cellContent.text = tagList[indexPath.row].name
        cell.contentConfiguration = cellContent
        
        if selectedTagPosition == indexPath.row {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
}
