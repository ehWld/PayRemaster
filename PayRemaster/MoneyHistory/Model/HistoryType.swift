//
//  Filter.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/04/03.
//

import Foundation

struct HistoryType: Decodable {
    let type: String
    let title: String
    
    static var all = HistoryType(type: "all", title: "전체")
}
