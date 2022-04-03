//
//  API.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/04/02.
//

import Foundation
import Combine

class API {
    private let tokenKey = "MoneyHistoryToken"

    static func accessToken() -> AnyPublisher<AccessToken, Error> {
        guard let token: AccessToken? = try? KeyChain.standard.object(forKey: tokenKey) else {
            
        }
        return HTTPClient.shared.request(urlString: "\(URL.Host.moneyHistory)/token")
    }
}
