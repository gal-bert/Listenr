//
//  TagTableCell+DragDelegate.swift
//  NYHM
//
//  Created by Rizki Faris on 17/06/22.
//

import Foundation
import UIKit

extension TagTableCell: UITableViewDragDelegate {

    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = tagArr[indexPath.row]
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedItem = tagArr[sourceIndexPath.row]
        
        tagArr.remove(at: sourceIndexPath.row)
        tagArr.insert(movedItem, at: destinationIndexPath.row)
        
        for (index, tag) in tagArr.enumerated() {
            
            tagRepo.update(name: tag.name!, position: Int64(index), item: tag)
        }
    }
}
