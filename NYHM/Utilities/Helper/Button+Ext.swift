//
//  Button+Ext.swift
//  NYHM
//
//  Created by Hafizh Mo on 16/06/22.
//

import UIKit

extension UIImage {
    
    func middImage() -> UIImage  {
        let middleConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        return withConfiguration(middleConfig)
    }
}
