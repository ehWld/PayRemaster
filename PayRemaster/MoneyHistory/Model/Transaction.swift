//
//  Transaction.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/03/31.
//

import Foundation

class Transaction: Decodable {
    let id: String
    let title: String
    let subtitle: String
    let date: Date
    let amount: Int
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case date = "transaction_at"
        case imageUrl = "image_url"
        case id, title, subtitle, amount
    }
    
    init(id: String, date: Date, amount: Int) {
        self.id = id
        self.date = date
        self.amount = amount
        self.title = "테스트"
        self.subtitle = "test"
        self.imageUrl = ""
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        subtitle = try values.decode(String.self, forKey: .subtitle)
        amount = try values.decode(Int.self, forKey: .amount)
        date = try values.decode(Date.self, forKey: .date)
        imageUrl = try values.decode(String.self, forKey: .imageUrl)
    }
}

extension Transaction: Hashable {
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.subtitle == rhs.subtitle &&
        lhs.date == rhs.date &&
        lhs.amount == rhs.amount &&
        lhs.imageUrl == rhs.imageUrl
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}
