//
//  DetailView.swift
//  NYHM
//
//  Created by Hafizh Mo on 14/06/22.
//

import Foundation
import UIKit

class DetailView: UIView {
    
    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var durationLeftLabel: UILabel!
    @IBOutlet weak var durationCurrentLabel: UILabel!
    
    func setup(data: Transcriptions) {
        
        titleTextView.text = data.title
        resultTextView.text = data.result
        
        createdAtLabel.text = data.createdAt?.formatDate()
        durationLabel.text = data.duration
        tagsLabel.text = data.tags
    }
    
    @IBAction func didTapPlay(_ sender: UIButton) {
        // give action here..
    }
    
    @IBAction func didTapBackward(_ sender: UIButton) {
        // give action here..
    }
    
    @IBAction func didTapForward(_ sender: UIButton) {
        // give action here..
    }
    
}
