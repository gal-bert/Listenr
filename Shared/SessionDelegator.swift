//
//  SessionDelegator.swift
//  NYHM
//
//  Created by Hafizh Mo on 22/06/22.
//

import Foundation
import WatchConnectivity

extension Notification.Name {
    static let dataDidFlow = Notification.Name("DataDidFlow")
    static let activationDidComplete = Notification.Name("ActivationDidComplete")
    static let reachabilityDidChange = Notification.Name("ReachablitiyDidChange")
}

class SessionDelegator: NSObject, WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        postNotificationOnMainQueueAsync(name: .activationDidComplete)
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        postNotificationOnMainQueueAsync(name: .reachabilityDidChange)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        var messageStatus = MessageStatus(phrase: .received)
        if message[MessageKeyLoad.isPlaying] != nil {
            messageStatus.isPlaying = IsPlaying(message)
        } else if message[MessageKeyLoad.isPausing] != nil {
            messageStatus.isPausing = IsPausing(message)
        } else if message[MessageKeyLoad.saving] != nil {
            messageStatus.saved = Saved(message)
        } else if message[MessageKeyLoad.canceling] != nil {
            messageStatus.canceled = Canceled(message)
        } else if message[MessageKeyLoad.result] != nil {
            messageStatus.message = Message(message)
        }
        postNotificationOnMainQueueAsync(name: .dataDidFlow, object: messageStatus)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        self.session(session, didReceiveMessage: message)
        replyHandler(message)
    }
    
    #if os(iOS)
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("\(#function): activationState = \(session.activationState.rawValue)")
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        print("\(#function): activationState = \(session.activationState.rawValue)")
    }
    #endif
    
    private func postNotificationOnMainQueueAsync(name: NSNotification.Name, object: MessageStatus? = nil) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: name, object: object)
        }
    }
}
