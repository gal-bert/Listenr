//
//  TagsModalViewController+Delegate.swift
//  NYHM
//
//  Created by Karen Natalia on 15/06/22.
//

import Foundation
import UIKit

extension TagsModalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tagSelected(tagName: tagList[indexPath.row].name!)
        dismiss(animated: true)
    }
}
