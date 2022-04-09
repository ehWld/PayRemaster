//
//  PayError.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/04/06.
//

import Foundation

enum PayError: Error {
    case forceUpdate
    case inspectionTime
    case dataNotFound
    case needToken
    case expiredToken
    case internalServerError
    case networkError
    case unhandled
}
