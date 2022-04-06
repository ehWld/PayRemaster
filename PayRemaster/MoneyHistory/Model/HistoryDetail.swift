//
//  HistoryDetail.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/04/06.
//

import Foundation

class HistoryDetail {
    let amount: Int
    let amountTitle: String
    let id: String
    let imageUrl: String
    let title: String
    let subtitle: String
    let date: Date
    let balance: Int
    let type: HistoryType
    
    init(_ dto: HistoryDetailDTO, _ type: HistoryType) {
        amount = dto.amount
        amountTitle = dto.amountTitle
        id = dto.id
        imageUrl = dto.imageUrl
        title = dto.title
        subtitle = dto.subtitle
        date = dto.date
        balance = dto.balance
        self.type = type
    }
}
