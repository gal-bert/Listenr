//
//  DetailViewController+Delegate.swift
//  NYHM
//
//  Created by Hafizh Mo on 15/06/22.
//

import Foundation
import FloatingPanel
import UIKit

extension DetailViewController: DetailDelegate {
    
    func didTapPlay(sender: UIButton) {
//        if isPlaying {
//            sender.setImage(UIImage(systemName: "play.fill")?.middImage(), for: .normal)
//            isPlaying = false
//            guard let player = audioPlayer else { return }
//            player.pause()
//            print("pausing...")
//            return
//        }
//
//        sender.setImage(UIImage(systemName: "pause.fill")?.middImage(), for: .normal)
//        isPlaying = true
//        guard let player = audioPlayer else { return }
//        player.play()
//        print("playing...")
    }
    
    func didTapBackward() {
        //TODO: add action here
    }
    
    func didTapForward() {
        //TODO: add action here
    }
    
    func didTapTags() {
        let fpc = FloatingPanelController(delegate: self)
        let layout = MyFloatingPanelLayout()
        fpc.layout = layout
        
        let storyboard = UIStoryboard(name: "TagsModal", bundle: nil)
        guard let tagsModalVC = storyboard.instantiateViewController(withIdentifier: "TagsModal") as? TagsModalViewController else {return}
        
        tagsModalVC.selectedTagName = transcription?.tags!
        tagsModalVC.delegate = self
        
        fpc.set(contentViewController: tagsModalVC)
        fpc.isRemovalInteractionEnabled = true
        fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 10.0
        fpc.surfaceView.appearance = appearance

        self.present(fpc, animated: true, completion: nil)
    }
    
    @objc func didTapShare() {
        //TODO: add action here
    }
}

extension DetailViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        if fpc.isAttracting == false {
            let loc = fpc.surfaceLocation
            let minY = fpc.surfaceLocation(for: .half).y - 16.0
            fpc.surfaceLocation = CGPoint(x: loc.x, y: max(loc.y, minY))
        }
    }
}

extension DetailViewController: TagsModalDelegate {
    func tagSelected(tagName: String) {
        detailView.tagsLabel.text = tagName
        TranscriptionRepository.shared.update(item: transcription!, newTitle: (transcription?.title)!, newResult: (transcription?.result)!, newTags: tagName)
    }
}
