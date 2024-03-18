//
//  Array+Ext.swift
//  GhFollowers
//
//  Created by Rami Elwan on 18.03.24.
//

import Foundation

extension Array {
    mutating func removeFirst(where predicate: (Element) -> Bool) {
        if let index = self.firstIndex(where: predicate) {
            self.remove(at: index)
        }
    }
}
