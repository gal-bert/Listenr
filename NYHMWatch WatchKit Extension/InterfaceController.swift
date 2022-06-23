//
//  InterfaceController.swift
//  NYHMWatch WatchKit Extension
//
//  Created by Hafizh Mo on 20/06/22.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, SessionManager {

    @IBOutlet weak var resultLabel: WKInterfaceLabel!
    @IBOutlet weak var pauseButton: WKInterfaceButton!
    @IBOutlet weak var saveButton: WKInterfaceButton!
    @IBOutlet weak var cancelButton: WKInterfaceButton!
    var isPlaying = false
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        resetUI()
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(type(of: self).dataDidFlow(_:)),
            name: .dataDidFlow, object: nil
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(type(of: self).activationDidComplete(_:)),
            name: .activationDidComplete, object: nil
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(type(of: self).reachabilityDidChange(_:)),
            name: .reachabilityDidChange, object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func dataDidFlow(_ notification: Notification) {
        guard let messageStatus = notification.object as? MessageStatus else { return }
        updateUI(with: messageStatus, errorMessage: messageStatus.errorMessage)
    }

    @objc
    func activationDidComplete(_ notification: Notification) {
        print("\(#function): activationState:\(WCSession.default.activationState.rawValue)")
    }
    
    @objc
    func reachabilityDidChange(_ notification: Notification) {
        print("\(#function): isReachable:\(WCSession.default.isReachable)")
    }
    
    private func updateUI(with messageStatus: MessageStatus, errorMessage: String? = nil) {
        if let errorMessage = errorMessage {
            resultLabel.setText("! \(errorMessage)")
            return
        }
        
        if messageStatus.message != nil {
            resultLabel.setText(messageStatus.message!.value + "\n")
            return
        }
        
        if messageStatus.starting != nil {
            if messageStatus.starting!.value {
                isPlaying = true
                updatePlayButton()
            }
            return
        }
        
        if messageStatus.isPlaying != nil {
            if messageStatus.isPlaying!.value {
                isPlaying = true
                updatePlayButton()
            }
            return
        }
        
        if messageStatus.isPausing != nil {
            if messageStatus.isPausing!.value {
                isPlaying = false
                updatePlayButton()
            }
            return
        }
        
        if messageStatus.saved != nil {
            if messageStatus.saved!.value {
                resetUI()
                return
            }
        }
        
        if messageStatus.canceled != nil {
            if messageStatus.canceled!.value {
                resetUI()
                return
            }
        }
    }
    
    func resetUI() {
        resultLabel.setText("Result will appear here..\n")
        cancelButton.setHidden(true)
        pauseButton.setHidden(true)
        saveButton.setHidden(true)
    }
    
    func updatePlayButton() {
        if isPlaying {
            pauseButton.setTitle("Stop")
            cancelButton.setHidden(false)
            pauseButton.setHidden(false)
            saveButton.setHidden(true)
        } else {
            pauseButton.setTitle("Start")
            saveButton.setHidden(false)
        }
    }
    
    @IBAction func didTapPause() {
        if isPlaying {
            sendIsPausing([MessageKeyLoad.isPausing: true])
            isPlaying = false
        } else {
            isPlaying = true
            sendIsPlaying([MessageKeyLoad.isPlaying: true])
        }
        updatePlayButton()
    }
    
    @IBAction func didTapSave() {
        sendSaving([MessageKeyLoad.saving: true])
        resetUI()
    }
    
    @IBAction func didTapCancel() {
        sendCanceling([MessageKeyLoad.canceling: true])
        resetUI()
    }
}
