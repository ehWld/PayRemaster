//
//  AccessToken.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/04/02.
//

import Foundation

struct AccessToken: Codable, Equatable {
    let expiredDate: Date
    let value: String
    
    var isValid: Bool {
        return expiredDate > Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case expiredDate = "expires_at"
        case value = "access_token"
    }
    
    init(_ value: String, expiredDate: Date) {
        self.value = value
        self.expiredDate = expiredDate
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        expiredDate = try values.decode(Date.self, forKey: .expiredDate)
        value = try values.decode(String.self, forKey: .value)
    }
}
