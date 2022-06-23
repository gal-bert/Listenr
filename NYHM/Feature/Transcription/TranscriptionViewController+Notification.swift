//
//  TranscriptionViewController+Notificaiton.swift
//  NYHM
//
//  Created by Hafizh Mo on 22/06/22.
//

import Foundation
import WatchConnectivity

extension TranscriptionViewController {
    
    private func updateReachabilityColor() {
        var isReachable = false
        if WCSession.default.activationState == .activated {
            isReachable = WCSession.default.isReachable
        }
        print("isReachable: \(isReachable)")
    }
    
    @objc
    func activationDidComplete(_ notification: Notification) {
        updateReachabilityColor()
    }
    
    @objc
    func reachabilityDidChange(_ notification: Notification) {
        updateReachabilityColor()
    }
    
    @objc
    func dataDidFlow(_ notification: Notification) {
        guard let messageStatus = notification.object as? MessageStatus else { return }
        
        if let errorMessage = messageStatus.errorMessage {
            print("! sendMessage...\(errorMessage)")
            return
        }
        
        if messageStatus.isPlaying != nil {
            if messageStatus.isPlaying!.value {
                transcribeOnLoad()
                print("inside if playing")
                return
            }
            print("outside if playing")
        }
        
        if messageStatus.isPausing != nil {
            if messageStatus.isPausing!.value {
                transcribeOnLoad()
                print("inside if pausing")
                return
            }
            print("outside if pausing")
        }
        
        if messageStatus.saved != nil {
            if messageStatus.saved!.value {
                globalSave()
                print("inside if save")
                return
            }
            print("outside if save")
        }
        
        if messageStatus.canceled != nil {
            if messageStatus.canceled!.value {
                globalCancel()
                print("inside if cancel")
                return
            }
            print("outside if cancel")
        }
    }
}
