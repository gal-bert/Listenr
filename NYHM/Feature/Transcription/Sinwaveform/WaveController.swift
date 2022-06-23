//
//  WaveController.swift
//  NYHM
//
//  Created by Rizki Faris on 22/06/22.
//

import Foundation
import UIKit


extension TranscriptionViewController {
    func startWave() {
        waveTimer = Timer.scheduledTimer(timeInterval: updateInterval,
                                     target: self,
                                     selector: #selector(self.updateMeters),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc private func updateMeters() {
        audioRecorder?.updateMeters()
        var power = averagePowerFromAllChannels()
        power = (120.0 + power) * -1
        print("powee", power)
        WavePreferences.wavesArray[0].amplitude = Double(power / 1)
    }
    
    // Calculate average power from all channels
    private func averagePowerFromAllChannels() -> CGFloat {
        var power: CGFloat = 0.0
//        power = (60.0 + power)
        // 2 indicates number of channel
        (0..<numberOfChannelForAudio).forEach { (index) in
            power = power + CGFloat(audioRecorder?.averagePower(forChannel: index) ?? 0)
        }
        
        return power / CGFloat(numberOfChannelForAudio)
    }
}

