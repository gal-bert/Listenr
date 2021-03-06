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
        let textConcat = "\(detailView.titleTextView.text ?? "")\n\nDuration: \(transcription?.duration ?? "")\nDate: \(transcription?.createdAt?.fixedFormat() ?? "")\nTag: \(detailView.tagsLabel.text ?? "")\n\n\(detailView.resultTextView.text ?? "")"
        let shareModal = UIActivityViewController(activityItems: [textConcat], applicationActivities: nil)
        shareModal.popoverPresentationController?.sourceView = self.view
        present(shareModal, animated: true)
    }
    
    func checkTagTruncate() {
        if detailView.maxLabelWidth! < detailView.tagsLabel.intrinsicContentSize.width {
            detailView.tagToSuperView.isActive = true
        }
        else {
            detailView.tagToSuperView.isActive = false
        }
    }
    
    func didTapDelete(item: Transcriptions) {
        
        let alert = UIAlertController(title: "Delete Transcription?", message: "Are you sure to delete this transcription?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(
            title: "Delete",
            style: .destructive,
            handler: { _ in
                let repo = TranscriptionRepository.shared
                repo.delete(item: item)
                self.navigationController?.popViewController(animated: true)
            }
        ))

        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        ))

        present(alert, animated: true)
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
        checkTagTruncate()
        TranscriptionRepository.shared.update(item: transcription!, newTitle: (transcription?.title)!, newResult: (transcription?.result)!, newTags: tagName)
    }
}
