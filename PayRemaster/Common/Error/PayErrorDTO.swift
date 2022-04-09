//
//  PayErrorDTO.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/04/09.
//

import Foundation

struct PayErrorDTO: Decodable {
    let error: Bool
    let reason: String
}
