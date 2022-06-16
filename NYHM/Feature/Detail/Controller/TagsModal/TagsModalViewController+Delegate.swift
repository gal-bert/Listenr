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
        /// TODO: Change selected tag in core data
        /// TODO: Trigger change the selected tag in detail
        dismiss(animated: true)
    }
}
