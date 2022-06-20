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
    
    func generateTimestampForFilename() -> String {
        let date = Date()
        let calendar = Calendar.current

        let year = calendar.component(.year, from:date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)

        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)

        let timestamp = "iHear_\(year)\(month)\(day)_\(hour)\(minute)\(second)"
        
        return timestamp
    }
    
}
