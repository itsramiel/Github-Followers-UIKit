//
//  Date+Ext.swift
//  GhFollowers
//
//  Created by Rami Elwan on 16.03.24.
//

import Foundation

extension Date {
    func convertToMonthYearFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: self)
    }
}
