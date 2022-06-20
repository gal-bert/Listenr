//
//  TranscriptionModalLayout.swift
//  NYHM
//
//  Created by Karen Natalia on 17/06/22.
//

import Foundation
import FloatingPanel

class  TranscriptionModalLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .full
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.35, edge: .bottom, referenceGuide: .safeArea)
        ]
    }
}
