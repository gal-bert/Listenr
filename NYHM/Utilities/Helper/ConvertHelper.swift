//
//  ConvertHelper.swift
//  NYHM
//
//  Created by Hafizh Mo on 16/06/22.
//

import AVFoundation
import UIKit

func convertToString(by currentTime : TimeInterval?) -> String? {
    guard let currentTime = currentTime else { return nil }
    let time = Int(currentTime)
    let min = time/60
    let sec = time%60
    let str = String(format: "%02d:%02d", min, sec)
    return str
}

func convertToTimeInterval(by player: AVAudioPlayer?,
                           _ progressBar: UIProgressView? ,
                           _ sender: UILongPressGestureRecognizer?) -> Double?  {
    guard let player = player,
          let progressBar = progressBar,
          let sender = sender else { return nil }
    
    var loc = sender.location(in: progressBar).x
    loc = max(loc,0)
    loc = min(loc, progressBar.frame.width)
    
    let percent = loc/progressBar.frame.width
    
    return Double(percent)*player.duration
}

func convertToString(by player: AVAudioPlayer?,
                     _ progressBar: UIProgressView? ,
                     _ sender: UILongPressGestureRecognizer?) -> String? {
    
    return convertToString(by: convertToTimeInterval(by: player, progressBar, sender))
}

func convertToProgressBarPercent(by player: AVAudioPlayer) -> Float {
    return Float(player.currentTime / player.duration)
}
