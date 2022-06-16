//
//  DetailController.swift
//  NYHM
//
//  Created by Hafizh Mo on 12/06/22.
//

import Foundation
import UIKit
import AVFAudio

class DetailViewController: UIViewController {
    @IBOutlet var detailView: DetailView!
    
    var transcription: Transcriptions?
//    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        
//        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let filename = path.appendingPathComponent("iHear_2022616_16405.m4a") // URL
//
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: filename)
//        }
//        catch {
//            print(error.localizedDescription)
//        }
        
        detailView.setup(data: transcription!, delegate: self)
        
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