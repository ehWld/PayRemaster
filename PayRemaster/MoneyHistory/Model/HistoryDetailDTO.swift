//
//  HistoryDetail.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/04/03.
//

import Foundation

class HistoryDetailDTO: Decodable {
    let amount: Int
    let amountTitle: String
    let id: String
    let imageUrl: String
    let title: String
    let subtitle: String
    let date: Date
    let type: String
    let balance: Int
    
    enum CodingKeys: String, CodingKey {
        case amountTitle = "amount_title"
        case imageUrl = "image_url"
        case date = "transaction_at"
        case type = "transaction_type"
        case amount, id, title, subtitle, balance
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        amount = (try values.decode(Int.self, forKey: .amount)) 
        amountTitle = try values.decode(String.self, forKey: .amountTitle)
        id = try values.decode(String.self, forKey: .id)
        imageUrl = try values.decode(String.self, forKey: .imageUrl)
        title = try values.decode(String.self, forKey: .title)
        subtitle = try values.decode(String.self, forKey: .subtitle)
        date = try values.decode(Date.self, forKey: .date)
        type = try values.decode(String.self, forKey: .type)
        balance = try values.decode(Int.self, forKey: .balance)
    }
}
