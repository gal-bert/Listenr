//
//  AddNewTagCell.swift
//  NYHM
//
//  Created by Rizki Faris on 18/06/22.
//

import Foundation
import UIKit

class AddNewTagCell: UITableViewCell {
    
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
        labelNewTagValue.isUserInteractionEnabled = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @IBOutlet weak var labelNewTagValue: UITextField!
}

protocol AddNewDelegate {
    func reloadData()
}
