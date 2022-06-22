//
//  SessionManager.swift
//  NYHM
//
//  Created by Hafizh Mo on 22/06/22.
//

import UIKit
import WatchConnectivity

protocol SessionManager {
    func sendMessage(_ value: [String: Any])
    func sendIsPlaying(_ value: [String: Any])
    func sendIsPausing(_ value: [String: Any])
    func sendSaving(_ value: [String: Any])
    func sendCanceling(_ value: [String: Any])
}

extension SessionManager {
    
    func sendMessage(_ value: [String: Any]) {
        var messageStatus = MessageStatus(phrase: .sent)
        messageStatus.message = Message(value)
        
        guard WCSession.default.activationState == .activated else {
            return handleSessionUnactivated(with: messageStatus)
        }
        
        WCSession.default.sendMessage(value, replyHandler: { replyValue in
            messageStatus.phrase = .replied
            messageStatus.message = Message(replyValue)
            self.postNotificationOnMainQueueAsync(name: .dataDidFlow, object: messageStatus)
        }, errorHandler: { error in
            messageStatus.phrase = .failed
            messageStatus.errorMessage = error.localizedDescription
            self.postNotificationOnMainQueueAsync(name: .dataDidFlow, object: messageStatus)
        })
    }
    
    func sendIsPlaying(_ value: [String: Any]) {
        var messageStatus = MessageStatus(phrase: .sent)
        messageStatus.isPlaying = IsPlaying(value)
        
        guard WCSession.default.activationState == .activated else {
            return handleSessionUnactivated(with: messageStatus)
        }
        
        WCSession.default.sendMessage(value, replyHandler: { _ in
            messageStatus.phrase = .replied
            messageStatus.isPlaying = IsPlaying([MessageKeyLoad.isPlaying: false])
            self.postNotificationOnMainQueueAsync(name: .dataDidFlow, object: messageStatus)
        }, errorHandler: { error in
            messageStatus.phrase = .failed
            messageStatus.errorMessage = error.localizedDescription
            self.postNotificationOnMainQueueAsync(name: .dataDidFlow, object: messageStatus)
        })
    }
    
    func sendIsPausing(_ value: [String: Any]) {
        var messageStatus = MessageStatus(phrase: .sent)
        messageStatus.isPausing = IsPausing(value)
        
        guard WCSession.default.activationState == .activated else {
            return handleSessionUnactivated(with: messageStatus)
        }
        
        WCSession.default.sendMessage(value, replyHandler: { _ in
            messageStatus.phrase = .replied
            messageStatus.isPausing = IsPausing([MessageKeyLoad.isPausing: false])
            self.postNotificationOnMainQueueAsync(name: .dataDidFlow, object: messageStatus)
        }, errorHandler: { error in
            messageStatus.phrase = .failed
            messageStatus.errorMessage = error.localizedDescription
            self.postNotificationOnMainQueueAsync(name: .dataDidFlow, object: messageStatus)
        })
    }
    
    func sendSaving(_ value: [String: Any]) {
        var messageStatus = MessageStatus(phrase: .sent)
        messageStatus.saved = Saved(value)
        
        guard WCSession.default.activationState == .activated else {
            return handleSessionUnactivated(with: messageStatus)
        }
        
        WCSession.default.sendMessage(value, replyHandler: { _ in
            messageStatus.phrase = .replied
            messageStatus.saved = Saved([MessageKeyLoad.saving: false])
            self.postNotificationOnMainQueueAsync(name: .dataDidFlow, object: messageStatus)
        }, errorHandler: { error in
            messageStatus.phrase = .failed
            messageStatus.errorMessage = error.localizedDescription
            self.postNotificationOnMainQueueAsync(name: .dataDidFlow, object: messageStatus)
        })
    }
    
    func sendCanceling(_ value: [String: Any]) {
        var messageStatus = MessageStatus(phrase: .sent)
        messageStatus.canceled = Canceled(value)
        
        guard WCSession.default.activationState == .activated else {
            return handleSessionUnactivated(with: messageStatus)
        }
        
        WCSession.default.sendMessage(value, replyHandler: { _ in
            messageStatus.phrase = .replied
            messageStatus.canceled = Canceled([MessageKeyLoad.canceling: false])
            self.postNotificationOnMainQueueAsync(name: .dataDidFlow, object: messageStatus)
        }, errorHandler: { error in
            messageStatus.phrase = .failed
            messageStatus.errorMessage = error.localizedDescription
            self.postNotificationOnMainQueueAsync(name: .dataDidFlow, object: messageStatus)
        })
    }
    
    private func postNotificationOnMainQueueAsync(name: NSNotification.Name, object: MessageStatus) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: name, object: object)
        }
    }
    
    private func handleSessionUnactivated(with messageStatus: MessageStatus) {
        var mutableStatus = messageStatus
        mutableStatus.phrase = .failed
        mutableStatus.errorMessage = "WCSession is not activated yet!"
        postNotificationOnMainQueueAsync(name: .dataDidFlow, object: messageStatus)
    }
}
