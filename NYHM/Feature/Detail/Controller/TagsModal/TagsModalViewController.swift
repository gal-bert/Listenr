//
//  TagsModalViewController.swift
//  NYHM
//
//  Created by Karen Natalia on 15/06/22.
//

import UIKit

class TagsModalViewController: UIViewController {
    
    @IBOutlet var tagsModalView: TagsModalView!
    
    let tagRepo = TagsRepository.shared
    var tagList = [Tags]()
    var selectedTagPosition:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagList = tagRepo.getAll()
        
        tagsModalView.setup(viewController: self)
    }
    
}
