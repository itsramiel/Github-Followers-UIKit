//
//  String+Ext.swift
//  GhFollowers
//
//  Created by Rami Elwan on 16.03.24.
//

import Foundation

extension String {
    func UTCStringToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        return dateFormatter.date(from: self)
    }
}
