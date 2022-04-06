//
//  Int+Extension.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/04/06.
//

import Foundation

extension Int {
    var wonFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formatted = formatter.string(from: NSNumber(value: self)) ?? String(self)
        return formatted + "원"
    }
}
