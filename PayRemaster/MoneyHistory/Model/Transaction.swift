//
//  Transaction.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/03/31.
//

import Foundation

class Transaction: Decodable {
    let id: String
    let date: Date
    let amount: Int
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case id = "transaction_id"
        case date = "transaction_at"
        case amount = ""
        case user
    }
    
    init(id: String, date: Date, amount: Int, user: User) {
        self.id = id
        self.date = date
        self.amount = amount
        self.user = user
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        amount = try values.decode(Int.self, forKey: .amount)
        user = try values.decode(User.self, forKey: .user)
        date = try values.decode(Date.self, forKey: .date)
        
        //        if let decoder = decoder as? JSONDecoder {
        //            decoder.dataDecodingStrategy = .iso8601
        //        }
    }
}

extension Transaction: Hashable {
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.id == rhs.id &&
        lhs.date == rhs.date &&
        lhs.amount == rhs.amount &&
        lhs.user == rhs.user
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}

class User: Decodable {
    let profileImage: String
    let id: String
    let nickname: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "user_profile_image"
        case id = "user_id"
        case nickname = "user_nick_name"
        case name = "user_name"
    }
    
    init() {
        profileImage = ""
        id = "ididididididididi"
        nickname = "닉네임닉네임닉네임"
        name = "이름이름이름이름"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        profileImage = try values.decode(String.self, forKey: .profileImage)
        id = try values.decode(String.self, forKey: .id)
        nickname = try values.decode(String.self, forKey: .nickname)
        name = try values.decode(String.self, forKey: .name)
    }
    
}

extension User: Hashable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.profileImage == rhs.profileImage &&
            lhs.id == rhs.id &&
            lhs.nickname == rhs.nickname &&
            lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
