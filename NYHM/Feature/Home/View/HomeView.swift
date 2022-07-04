//
//  HomeView.swift
//  NYHM
//
//  Created by Hafizh Mo on 14/06/22.
//

import Foundation
import UIKit
import Lottie


class HomeView: UIView {
    
    
    //Label Empty State
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var boldLabel: UILabel!
    @IBOutlet weak var lottieView: AnimationView!
    @IBOutlet weak var vertView: UIStackView!
    
    
    @IBOutlet weak var labelColor: UILabel!
    @IBOutlet weak var bgLanguage: UIView!
    @IBOutlet weak var bgButton: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortButton: UIBarButtonItem!
    @IBOutlet weak var languageLabel: UILabel!
    
    private var delegate: HomeDelegate?
    
    lazy var castedDelegate = delegate as! HomeViewController
    
    func setup(viewController: HomeViewController) {
        delegate = viewController
        
        tableView.delegate = viewController
        tableView.dataSource = viewController
        tableView.registerCell(type: ItemHomeCell.self, identifier: "itemHomeCell")
        
        generatePopOverMenu()
        
        let savedLanguage = UserDefaults.standard.string(forKey: Constants.SELECTED_LANGUAGE)
        
        if savedLanguage! == "id" {
            languageLabel.text = "Bahasa Indonesia"
        } else {
            languageLabel.text = "English"
        }
        
        
        labelColor.textColor = UIColor (named: "textPrim")
        languageLabel.textColor = UIColor (named: "actionPress")
        
        //Color For Dark Mode to Light Mode
        
        
        let secBg = UIColor(named: "secBg")
        let primBg = UIColor(named: "primBg")
        let thBg = UIColor(named: "thirdBg")
        
        tableView.backgroundColor = primBg
        bgLanguage.backgroundColor = thBg
        bgButton.backgroundColor = secBg
        
      
        
        
        self.backgroundColor = primBg
        
        
        lottieView.contentMode = .scaleAspectFill
        //lottieView.translatesAutoresizingMaskIntoConstraints = false
        
        lottieView.play()
        lottieView.loopMode = .loop
        lottieView.backgroundBehavior = .pauseAndRestore
     
        

                let imageAttachment = NSTextAttachment()
                let theImage = UIImage(systemName: "mic.fill")?.withRenderingMode(.alwaysTemplate)
                imageAttachment.image = theImage
                let boldLabelPlacement = NSMutableAttributedString(string: "No Transcription available")
                let stringPlaceWithIcon = NSMutableAttributedString(string: "\nClick the ")
                stringPlaceWithIcon.append(NSAttributedString(attachment: imageAttachment))
                stringPlaceWithIcon.append(NSAttributedString(string: " button to create a new transcription"))
                boldLabel.attributedText = boldLabelPlacement
                emptyLabel.attributedText = stringPlaceWithIcon
        
        
        
    }
    
    @IBAction func didTapLanguage(_ sender: Any) {
        delegate?.chooseLanguage()
    }
    
    @IBAction func transcribeButton(_ sender: Any) {
        delegate?.showTranscriptionModal()
    }
    
    func generatePopOverMenu() {
        let viewController = delegate as! HomeViewController
        
        var menuAlphabetAsc = UIAction(title: SortType.alphabetAsc.rawValue, image: nil, handler: { (_) in
            self.delegate?.sortBy(type: .alphabetAsc)
        })
        var menuAlphabetDesc = UIAction(title: SortType.alphabetDesc.rawValue, image: nil, handler: { (_) in
            self.delegate?.sortBy(type: .alphabetDesc)
        })
        var menuTimeAsc = UIAction(title: SortType.timeAsc.rawValue, image: nil, handler: { (_) in
            self.delegate?.sortBy(type: .timeAsc)
        })
        var menuTimeDesc = UIAction(title: SortType.timeDesc.rawValue, image: nil, handler: { (_) in
            self.delegate?.sortBy(type: .timeDesc)
        })
        
        switch viewController.currentSort {
        case .alphabetAsc:
            menuAlphabetAsc = UIAction(title: SortType.alphabetAsc.rawValue, image: UIImage(systemName: "checkmark"), handler: { (_) in
                self.delegate?.sortBy(type: .alphabetAsc)
            })
        case .alphabetDesc:
            menuAlphabetDesc = UIAction(title: SortType.alphabetDesc.rawValue, image: UIImage(systemName: "checkmark"), handler: { (_) in
                self.delegate?.sortBy(type: .alphabetDesc)
            })
        case .timeAsc:
            menuTimeAsc = UIAction(title: SortType.timeAsc.rawValue, image: UIImage(systemName: "checkmark"), handler: { (_) in
                self.delegate?.sortBy(type: .timeAsc)
            })
        case .timeDesc:
            menuTimeDesc = UIAction(title: SortType.timeDesc.rawValue, image: UIImage(systemName: "checkmark"), handler: { (_) in
                self.delegate?.sortBy(type: .timeDesc)
            })
        }
        
        var menuItems: [UIAction] {
            return [
                menuAlphabetAsc,
                menuAlphabetDesc,
                menuTimeAsc,
                menuTimeDesc
            ]
        }
        
        
        sortButton.menu = UIMenu(title: "Sort by", image: nil, identifier: nil, options: [], children: menuItems)
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
    }
}
