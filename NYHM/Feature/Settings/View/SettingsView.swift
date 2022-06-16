//
//  SettingsView.swift
//  NYHM
//
//  Created by Rizki Faris on 14/06/22.
//

import Foundation
import UIKit

class SettingsView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var viewController: SettingsViewController?
    
    func setup(viewController: SettingsViewController) {
        self.viewController = viewController
        tableView.delegate = viewController
        tableView.dataSource = viewController
        
        tableView.registerCell(type: WaveformSwitchCell.self, identifier: WaveformSwitchCell.identifier)
        
    }
}