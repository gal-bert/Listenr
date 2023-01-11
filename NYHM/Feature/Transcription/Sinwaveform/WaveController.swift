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
        waveformTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true, block: { [self] timer in
            self.audioRecorder?.updateMeters()
            self.writeWaves((self.audioRecorder?.averagePower(forChannel: 0)) ?? 0, true, waveCounterTimer)
            
            waveCounterTimer += 1
        })
    }
    
    func writeWaves(_ input: Float, _ bool: Bool, _ count: CGFloat) {
        if !bool {
            start = firstPoint
            if waveformTimer != nil || audioRecorder != nil {
                waveformTimer.invalidate()
            }
            return
        }
        else {
            if input < -55 {
                amplitudeLength = 0.2
            }
            else if input < -40 && input > -55 {
                amplitudeLength = (CGFloat(input) + 56) / 3
            }
            else if input < -20 && input > -40 {
                amplitudeLength = (CGFloat(input) + 41) / 2
            }
            else if input < -10 && input > -20 {
                amplitudeLength = (CGFloat(input) + 21) * 5
            }
            else {
                amplitudeLength = (CGFloat(input) + 20) * 4
            }
            
            pencil.move(to: start)
            pencil.addLine(to: CGPoint(x: start.x, y: start.y + amplitudeLength))
            
            pencil.move(to: start)
            pencil.addLine(to: CGPoint(x: start.x, y: start.y - amplitudeLength))
            
            waveLayer.path = pencil.cgPath
            waveLayer.strokeColor = UIColor(named: "blueText")?.cgColor
            waveLayer.fillColor = UIColor.clear.cgColor
            waveLayer.lineWidth = 1
            waveLayer.position = CGPoint(x: 0 - (space * count), y: 0)

            waveformView.layer.addSublayer(waveLayer)
            waveformView.setNeedsDisplay()
            
            start = CGPoint(x: start.x + space, y: start.y)
            
        }
    }
}

