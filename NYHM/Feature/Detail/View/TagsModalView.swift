//
//  TagsModalView.swift
//  NYHM
//
//  Created by Karen Natalia on 15/06/22.
//

import UIKit

class TagsModalView: UIView {

    @IBOutlet weak var tagTableView: UITableView!
    
    weak var delegate: TagsModalDelegate?
    
    func setup(viewController: TagsModalViewController) {
        tagTableView.delegate = viewController
        tagTableView.dataSource = viewController
        
        delegate = viewController
    }
    
    @IBAction func addNewTag(_ sender: Any) {
        delegate?.addNewTag()
    }
}
