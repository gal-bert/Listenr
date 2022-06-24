//
//  WaveController.swift
//  NYHM
//
//  Created by Rizki Faris on 22/06/22.
//

import Foundation
import UIKit


extension TranscriptionViewController {
    
    func turnTheWave(bool: Bool) {
        if bool {
            // prevent redundant
            if self.view.viewWithTag(378) != nil {
//                viewTagSineWave.removeFromSuperview()
                print("already had sinewaveview 378")
            } else {
                print("create sinewaveview tag 378")
                sineWaveView = waveView.theView
                sineWaveView.tag = 378
                view.addSubview(sineWaveView)
                waveView.setup(x: 0, y: (Int(self.view.frame.size.height) - Int(320)), width: Int(self.view.frame.size.width), height: Int(10))
            }
        } else {
            if let viewTagSineWave = self.view.viewWithTag(378) {
                
                viewTagSineWave.removeFromSuperview()
                print("view 378 deleted")
            } else {
                print("failed to remove view 378 sinewave")
            }
        }
    }
    
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
        // -120 is minimum loudness, and 0 power input means the highest power, so to covert it, is SUM 120 to the power so the outcomes would be opposite of power
        power = (120.0 + power)
        if power <= 30.0 {
            power = power / 9
        } else if power > 30 && power <= 40 {
            power = power / 7
        } else if power > 40 && power <= 50 {
            power = power / 6
        } else if power > 50 && power <= 55 {
            power = power / 5
        } else if power > 55 && power <= 60 {
            power = power / 4.5
        } else if power > 60 && power <= 65 {
            power = power / 4
        } else if power > 65 && power <= 70 {
            power = power / 3.5
        } else if power > 70 && power <= 75 {
            power = power / 3
        } else if power > 70 && power < 80 {
            power = power / 2.8
        } else if power > 80 && power <= 85 {
            power = power / 2.5
        } else if power > 85 && power <= 90 {
            power = power / 2.3
        } else if power > 90 && power <= 100 {
            power = power / 2
        } else if power > 100 && power <= 110 {
            power = power / 1.8
        } else if power > 110 && power <= 115 {
            power = power / 1.7
        } else if power > 115 && power <= 120 {
            power = power / 1.6
        }
        WavePreferences.wavesArray[0].amplitude = Double(power / 1)
    }
    
    // Calculate average power from all channels
    private func averagePowerFromAllChannels() -> CGFloat {
        var power: CGFloat = 0.0
        // 2 indicates number of channel
        (0..<numberOfChannelForAudio).forEach { (index) in
            power = power + CGFloat(audioRecorder?.averagePower(forChannel: index) ?? 0)
        }
        
        return power / CGFloat(numberOfChannelForAudio)
    }
}

