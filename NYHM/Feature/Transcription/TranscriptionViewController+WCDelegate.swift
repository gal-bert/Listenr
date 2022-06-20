//
//  TranscriptionViewController+WCDelegate.swift
//  NYHM
//
//  Created by Hafizh Mo on 20/06/22.
//

import Foundation
import WatchConnectivity

extension TranscriptionViewController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        //
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //
    }
    
}
