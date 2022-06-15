//
//  DetailController.swift
//  NYHM
//
//  Created by Hafizh Mo on 12/06/22.
//

import Foundation
import UIKit
import FloatingPanel

class DetailViewController: UIViewController {
    
    @IBAction func showModal(_ sender: Any) {
        let fpc = FloatingPanelController(delegate: self)
        let layout = MyFloatingPanelLayout()
        fpc.layout = layout
        
        let storyboard = UIStoryboard(name: "TagsModal", bundle: nil)
        guard let tagsModalVC = storyboard.instantiateViewController(withIdentifier: "TagsModal") as? TagsModalViewController else {return}
        
        fpc.set(contentViewController: tagsModalVC)
        fpc.isRemovalInteractionEnabled = true
        
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 10.0
        fpc.surfaceView.appearance = appearance

        self.present(fpc, animated: true, completion: nil)
    }
}

class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .half
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.35, edge: .bottom, referenceGuide: .safeArea)
        ]
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
