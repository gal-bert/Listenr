//
//  Alerts.swift
//  NYHM
//
//  Created by Gregorius Albert on 21/06/22.
//

import UIKit

class Alerts {
    
    static func pushAlert(title:String, message:String, destructiveMessage:String, completionIfDestructive:() ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        ))
        
        alert.addAction(UIAlertAction(
            title: destructiveMessage,
            style: .destructive,
            handler: { _ in
                completionIfDestructive
            }
        ))
        
        return alert
    }
    

    
}
