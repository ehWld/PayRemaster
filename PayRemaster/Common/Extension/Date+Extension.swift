//
//  Date+Extension.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/03/31.
//

import Foundation

extension Date {
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }
}

extension Date {
    func formattedString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko")
        return formatter.string(from: self)
    }
}

extension Date {
    func advanced(by component: Calendar.Component, value: Int) -> Date {
        let newDate = Calendar.current.date(byAdding: component, value: value, to: self)
        return newDate ?? self
    }
}
