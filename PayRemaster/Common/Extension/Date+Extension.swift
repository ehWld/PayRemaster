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
        return Calendar.current.component(.year, from: self)
    }
}
