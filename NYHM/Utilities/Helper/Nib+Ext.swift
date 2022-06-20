//
//  Nib+Ext.swift
//  NYHM
//
//  Created by Hafizh Mo on 14/06/22.
//

import Foundation
import UIKit

extension UINib {
    static func nib(_ nibName: String) -> UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
    
    static func loadSingleView(_ nibName: String, owner: Any?) -> UIView {
        return nib(nibName).instantiate(withOwner: owner, options: nil).first as! UIView
    }
    
    class func loadView(_ owner: AnyObject) -> UIView {
        return loadSingleView("\(owner.self)", owner: owner)
    }
}
