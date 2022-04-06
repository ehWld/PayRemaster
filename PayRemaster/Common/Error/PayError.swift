//
//  PayError.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/04/06.
//

import Foundation

enum PayError: Error {
    case needToken
    case expiredToken
    case dataNotFound
    case internalServerError
    case forceUpdate
    case inspectionTime
}
