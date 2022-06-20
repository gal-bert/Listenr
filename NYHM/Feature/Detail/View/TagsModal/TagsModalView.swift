//
//  TagsModalView.swift
//  NYHM
//
//  Created by Karen Natalia on 15/06/22.
//

import UIKit

class TagsModalView: UIView {

    @IBOutlet weak var tagTableView: UITableView!
    
    weak var alertDelegate: TagsModalViewController?
    var delegate: TagsModalDelegate?
    
    var tagList = [Tags]()
    
    func setup(viewController: TagsModalViewController) {
        tagTableView.delegate = viewController
        tagTableView.dataSource = viewController
        
        alertDelegate = viewController
        delegate = viewController as? TagsModalDelegate
        tagList = viewController.tagList
    }
    
    @IBAction func addNewTag(_ sender: Any) {
        alertDelegate?.addNewTag(tagCount: tagList.count, delegate: alertDelegate!)
    }
}
