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
        
        if #available(iOS 13.0, *) {
            let statusBar =  UIView()
            statusBar.frame = UIApplication.shared.keyWindow?.windowScene?.statusBarManager!.statusBarFrame as! CGRect
            statusBar.backgroundColor = navigationController?.navigationBar.backgroundColor
            UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
            let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
            statusBar.backgroundColor = navigationController?.navigationBar.backgroundColor
        }
        
    }
}
