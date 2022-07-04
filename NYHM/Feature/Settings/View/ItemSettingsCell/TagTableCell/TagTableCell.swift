//
//  TagTableCell.swift
//  NYHM
//
//  Created by Rizki Faris on 15/06/22.
//

import Foundation
import UIKit


class TagTableCell : UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    private var viewController: SettingsViewController?
    var delegate: AddNewDelegate?
    
    let tagRepo = TagsRepository.shared
    var tagArr = [Tags]()
    
    @IBOutlet weak var tagTableview: UITableView!
    static let identifier = "tagTableCellSB"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tagTableview.delegate = self
        tagTableview.dataSource = self
        tagTableview.dragDelegate = self

        tagTableview.dragInteractionEnabled = true
        
        tagArr = tagRepo.getAll()
        tagTableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        tagTableview.backgroundColor = UIColor(named: "secBg")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.tagArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagItemCell", for: indexPath)
        
        cell.backgroundColor = UIColor(named: "secBg")
        
        var tag = cell.defaultContentConfiguration()
//        tag.textProperties.color = .white
        tag.text = tagArr[indexPath.row].name
        
        tag.image = UIImage(systemName: "line.3.horizontal")
        tag.imageProperties.tintColor = .lightGray
        cell.contentConfiguration = tag
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat(50)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tagRepo.delete(item: tagArr[indexPath.row])
            tagArr = tagRepo.getAll()
            
            for (index, tag) in tagArr.enumerated() {
                tagRepo.update(name: tag.name!, position: Int64(index), item: tag)
            }
            
            tableView.reloadData()
            delegate?.reloadData()
        }
    }
    
}
