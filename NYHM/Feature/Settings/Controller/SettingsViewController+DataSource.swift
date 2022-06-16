//
//  SettingsViewController+DataSource.swift
//  NYHM
//
//  Created by Rizki Faris on 15/06/22.
//

import Foundation
import UIKit

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: WaveformSwitchCell.identifier, for: indexPath) as! WaveformSwitchCell
    //        cell.textLabel?.text = "HELL"
            return cell
//        } else {
//            let cell : CustomCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomCell
//            return cell
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return CGFloat(110)
        } else {
            return tableView.rowHeight
        }
    }
    
}
