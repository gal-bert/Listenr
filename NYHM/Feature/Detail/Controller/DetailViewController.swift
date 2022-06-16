//
//  DetailController.swift
//  NYHM
//
//  Created by Hafizh Mo on 12/06/22.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var detailView: DetailView!
    
    var transcription: Transcriptions?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailView.setup(data: transcription!, delegate: self)
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let newTags = detailView.tagsLabel.text!
        let newTitle = detailView.titleTextView.text!
        let newResult = detailView.resultTextView.text!
        
        let isTagsChange = newTags != transcription?.tags
        let isTitleChange = newTitle != transcription?.title
        let isResultChange = newResult != transcription?.result
        
        if (isTagsChange || isTitleChange || isResultChange) {
            TranscriptionRepository.shared.update(item: transcription!, newTitle: newTitle, newResult: newResult, newTags: newTags)
        }
    }
}
