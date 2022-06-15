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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        insertDummyTagList()
        tagList = tagRepo.getAll()
        
        tagsModalView.setup(viewController: self)
    }
    
    func insertDummyTagList() {
        tagRepo.add(name: "Tag 1", position: 1)
        tagRepo.add(name: "Tag 2", position: 2)
        tagRepo.add(name: "Tag 3", position: 3)
        tagRepo.add(name: "Tag 4", position: 4)
        tagRepo.add(name: "Tag 5", position: 5)
        tagRepo.add(name: "Tag 6", position: 6)
    }
}
