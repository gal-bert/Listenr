//
//  UserDefault.swift
//  NYHM
//
//  Created by Rizki Faris on 13/06/22.
//

import Foundation

extension UserDefaults {
    
    enum Key: String {
        case waveformVisibility
    }
    
    func isWaveformVisible() -> Bool{
        UserDefaults.standard.bool(forKey: Key.waveformVisibility.rawValue)
    }
    
    func handleShowWaveform() {
        UserDefaults.standard.set(true, forKey: Key.waveformVisibility.rawValue)
    }
    
    func handleHideWaveform() {
        UserDefaults.standard.set(false, forKey: Key.waveformVisibility.rawValue)
    }
}
