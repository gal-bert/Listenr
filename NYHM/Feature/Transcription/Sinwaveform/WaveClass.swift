//
//  WaveClass.swift
//  NYHM
//
//  Created by Rizki Faris on 22/06/22.
//

import Foundation
import UIKit

class WaveClass {
    var amplitude: Double!
    var frequency: Double!
    var color: UIColor!
    var time: Double = 0
    var phase: Double = 0
    let shapeLayer = CAShapeLayer()
 
    init(frequency: Double, amplitude: Double, color: UIColor) {
        self.frequency = frequency
        self.amplitude = amplitude
        self.color = color
    }
 
    func timeWaveStep(timer: Double) {
        time += timer
    }
    
}
