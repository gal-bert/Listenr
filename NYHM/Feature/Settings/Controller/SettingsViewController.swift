//
//  SettingsViewController.swift
//  NYHM
//
//  Created by Hafizh Mo on 12/06/22.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet var settingsView: SettingsView!
    
    let tagRepo = TagsRepository.shared
    var tagArr = [Tags]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagArr = tagRepo.getAll()
        settingsView.setup(viewController: self)
        self.view.endEditing(true)
        
        let secBg = UIColor(named: "secBg")
        view.backgroundColor = secBg
        
    }
}
