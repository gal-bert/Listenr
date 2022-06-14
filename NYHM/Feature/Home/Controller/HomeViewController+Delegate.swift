//
//  HomeViewController+Delegate.swift
//  NYHM
//
//  Created by Hafizh Mo on 14/06/22.
//

import Foundation
import UIKit

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detail = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            self.navigationController?.pushViewController(detail, animated: true)
        }
    }
}
