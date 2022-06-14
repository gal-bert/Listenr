//
//  TableView+Ext.swift
//  NYHM
//
//  Created by Hafizh Mo on 14/06/22.
//

import Foundation
import UIKit

extension UITableView {
    func registerCell(type: UITableViewCell.Type, identifier: String) {
        let nib = UINib.nib("\(type)")
        self.register(nib, forCellReuseIdentifier: identifier)
    }
}
