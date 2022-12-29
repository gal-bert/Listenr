//
//  DetailController.swift
//  NYHM
//
//  Created by Hafizh Mo on 12/06/22.
//

import Foundation
import UIKit
import AVFAudio

class DetailViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var detailView: DetailView!
    
    var transcription: Transcriptions?
//    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.generatePopOverMenu()
        navigationItem.largeTitleDisplayMode = .never
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        
        navigationItem.rightBarButtonItem = detailView.popOverButton
        
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
        
        detailView.titleTextView.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        view.addGestureRecognizer(tap)
        self.navigationItem.titleView?.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveOnClose), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveAndStop()
    }
    
    func saveAndStop() {
        let newTags = detailView.tagsLabel.text! == "Add Tags" ? "Untagged" : detailView.tagsLabel.text!
        let newTitle = detailView.titleTextView.text!
        let newResult = detailView.resultTextView.text!
        
        let isTagsChange = newTags != transcription?.tags
        let isTitleChange = newTitle != transcription?.title
        let isResultChange = newResult != transcription?.result
        
        if (isTagsChange || isTitleChange || isResultChange) {
            TranscriptionRepository.shared.update(item: transcription!, newTitle: newTitle, newResult: newResult, newTags: newTags)
        }
        
        detailView.player?.stop()
    }
    
    @objc func saveOnClose() {
        saveAndStop()
    }
    
    @objc func handleTap() {
        detailView.titleTextView.resignFirstResponder()// dismiss keyoard
        detailView.resultTextView.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            detailView.titleTextView.resignFirstResponder()
            return false
        }
        return true
    }
}
