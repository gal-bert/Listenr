//
//  InterfaceController.swift
//  NYHMWatch WatchKit Extension
//
//  Created by Hafizh Mo on 20/06/22.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var resultLabel: WKInterfaceLabel!
    var session = WCSession.default
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        
        session.delegate = self
        session.activate()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

}


extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let dataFromPhone = message["result"] as? String {
            self.resultLabel.setText(dataFromPhone)
        }
    }
}
