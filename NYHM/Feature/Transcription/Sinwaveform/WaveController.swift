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
        waveformTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [self] timer in
            self.audioRecorder?.updateMeters()
            self.writeWaves((self.audioRecorder?.averagePower(forChannel: 0)) ?? 0, true, waveCounterTimer)
            
            waveCounterTimer += 1
        })
    }
    
    func writeWaves(_ input: Float, _ bool: Bool, _ count: CGFloat) {
        if !bool {
            self.start = firstPoint
            if waveformTimer != nil || audioRecorder != nil {
                waveformTimer.invalidate()
            }
            return
        }
        else {
            if input < -55 {
                self.amplitudeLength = 0.2
            }
            else if input < -40 && input > -55 {
                self.amplitudeLength = (CGFloat(input) + 56) / 3
            }
            else if input < -20 && input > -40 {
                self.amplitudeLength = (CGFloat(input) + 41) / 2
            }
            else if input < -10 && input > -20 {
                self.amplitudeLength = (CGFloat(input) + 21) * 5
            }
            else {
                self.amplitudeLength = (CGFloat(input) + 20) * 4
            }
            
            DispatchQueue.main.async {
                self.pencil.move(to: self.start)
                self.pencil.addLine(to: CGPoint(x: self.start.x , y: self.start.y + self.amplitudeLength))
                
                self.pencil.move(to: self.start)
                self.pencil.addLine(to: CGPoint(x: self.start.x, y: self.start.y - self.amplitudeLength))
                
                self.waveLayer.path = self.pencil.cgPath
                self.waveLayer.strokeColor = UIColor(named: "blueText")?.cgColor
                self.waveLayer.fillColor = UIColor.clear.cgColor
                self.waveLayer.lineWidth = 1
                self.waveLayer.position = CGPoint(x: 0 - (self.space * count), y: 0)
                
                self.waveformView.layer.addSublayer(self.waveLayer)
                self.waveformView.setNeedsDisplay()
                
                self.start = CGPoint(x: self.start.x + self.space, y: self.start.y)
            }
            
            
        }
    }
}

