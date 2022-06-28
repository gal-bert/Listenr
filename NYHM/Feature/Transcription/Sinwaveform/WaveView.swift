//
//  WaveView.swift
//  NYHM
//
//  Created by Rizki Faris on 22/06/22.
//

import UIKit

func getAtIndex(index: Int) -> WaveClass {
    return WavePreferences.wavesArray[index]
}

class WaveView {
    
    var theView = UIView()
    var centerY = 0.0
    var stepAxis_coordinates_X = 0.0
    var steps = 300
    let shapeLayer = CAShapeLayer()
    var timer: Timer!
    var refresherTime = 0
    // increasing speed, higher means faster
    let waveSpeed = 0.18
    
    let sumPath = UIBezierPath()
    
    // MARK: - Setup
    
    
    func setup(x: Int, y: Int, width: Int, height: Int) {
        theView.frame = CGRect(x: x, y: y, width: width, height: height)
        theView.backgroundColor = .clear
        
        theView.layer.addSublayer(shapeLayer)
        
        centerY = Double(theView.frame.height) / 2
        stepAxis_coordinates_X = Double(theView.frame.width / CGFloat(steps))
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(onTimer(timer:)), userInfo: nil, repeats: true)
        } else {
            timer.invalidate()
        }
    }
    
    func restartTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(onTimer(timer:)), userInfo: nil, repeats: true)
    }
 
    @objc func onTimer(timer: Timer) {
        refresherTime += 1
        // function to refresh timer, prevent infinite loop
        if refresherTime > 2000 {
            timer.invalidate()
            // delayed function
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.restartTimer()
                self.refresherTime = 0
            }
        }
        drawSineWaves()
    }
    
    
    func drawSineWaves() {

        var sinSum = Array<CGFloat>(repeating: 0, count: steps)
        
        for i in 0..<WavePreferences.wavesArray.count {
            let path = UIBezierPath()
            let sine = getAtIndex(index: i)
            
            sine.timeWaveStep(timer: waveSpeed)
            
            let f = Double.pi * 2 / Double(steps) * sine.frequency
            
            for p in 0..<steps {
                let inc = Double(p)
                let x = inc * stepAxis_coordinates_X
                let y = sin((Double(p) * f) + sine.phase + sine.time) * sine.amplitude
                sinSum[p] += CGFloat(y)
                if p == 0 {
                    path.move(to: CGPoint(x: x, y: y + centerY))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y + centerY))
                }
            }
            
            sine.shapeLayer.path = path.cgPath
            
            theView.layer.addSublayer(sine.shapeLayer)
            sine.shapeLayer.lineWidth = 2
            sine.shapeLayer.fillColor = UIColor.clear.cgColor
            sine.shapeLayer.strokeColor = sine.color.cgColor
        }
        
        sumPath.move(to: CGPoint(x: 0, y:sinSum[0] + CGFloat(centerY)))
    }
}
