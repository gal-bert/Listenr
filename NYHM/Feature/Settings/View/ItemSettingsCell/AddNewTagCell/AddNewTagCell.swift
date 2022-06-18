//
//  AddNewTagCell.swift
//  NYHM
//
//  Created by Rizki Faris on 18/06/22.
//

import Foundation
import UIKit

class AddNewTagCell: UITableViewCell {
    
    private var settingController : SettingsViewController?
    
    let tagRepo = TagsRepository.shared
    
    static let identifier = "AddNewTagCellSB"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)// Note the !
        ]
        labelNewTagValue.attributedPlaceholder = NSAttributedString(
            string: "Add New Tag",
            attributes: attributes
        )
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @IBOutlet weak var labelNewTagValue: UITextField!
    @IBAction func newTagEndOnExit(_ sender: UITextField) {
        
        let tagArr = tagRepo.getAll()
        if labelNewTagValue.text != "" {
            if tagArr.count > 0 {
                let lastPosition = tagArr[tagArr.count - 1].position
                tagRepo.add(name: labelNewTagValue.text!, position: Int(lastPosition))
            } else {
                tagRepo.add(name: labelNewTagValue.text!, position: 1)
            }
        }
        labelNewTagValue.text = ""
        
//        TagTableCell.fetchData()
    }
}
