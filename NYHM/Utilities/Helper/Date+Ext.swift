//
//  Date+Ext.swift
//  NYHM
//
//  Created by Hafizh Mo on 14/06/22.
//

import Foundation

extension Date {
    func fixedFormat() -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "dd MMM yyyy"
        return dateformat.string(from: self)
    }
}
