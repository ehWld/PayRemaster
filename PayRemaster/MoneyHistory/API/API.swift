//
//  API.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/04/02.
//

import Foundation
import Combine

class API {
    static func accessToken() -> AnyPublisher<AccessToken, Error> {
        let tokenKey = "MoneyHistoryToken"
        var token: AccessToken?
        do {
            token = try KeyChain.standard.object(forKey: tokenKey)
        } catch let error {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        guard let token = token,
              token.isValid else {
            return requestAccessToken()
        }
        return Just(token).tryMap{ $0 }.eraseToAnyPublisher()
    }
    
    static func requestAccessToken() -> AnyPublisher<AccessToken, Error> {
        let tokenKey = "MoneyHistoryToken"
        let publisher: AnyPublisher<AccessToken, Error> = HTTPClient.shared.request(urlString: "\(URL.Host.moneyHistory)/token")
        
        return publisher
            .tryMap {
                try KeyChain.standard.set($0, forKey: tokenKey)
                return $0
            }
            .eraseToAnyPublisher()
    }
    
    static func histories(category: String? = nil, month: Int? = nil, page: Int? = nil) -> AnyPublisher<[History], Error> {
        let urlString = "\(URL.Host.moneyHistory)/money/histories"
        var parameters: [String: String] = [:]
        
        if let category = category {
            parameters["category"] = category
        }
        if let month = month {
            parameters["month"] = String(month)
        }
        if let page = page {
            parameters["page"] = String(page)
        }
        
        return accessToken().flatMap { token -> AnyPublisher<[History], Error> in
            let header = ["Authorization": token.value]
            return HTTPClient.shared.request(urlString: urlString, headers: header, parameters: parameters)
        }
        .eraseToAnyPublisher()
    }
    
    static func historyDetail(of id: String) -> AnyPublisher<HistoryDetail, Error> {
        return accessToken().flatMap { token -> AnyPublisher<HistoryDetail, Error> in
            let header = ["Authorization": token.value]
            let urlString = "\(URL.Host.moneyHistory)/money/detail/\(id)"
            return HTTPClient.shared.request(urlString: urlString, headers: header)
        }
        .eraseToAnyPublisher()
    }
    
    static func categories() -> AnyPublisher<[Filter], Error> {
        return accessToken().flatMap { token -> AnyPublisher<[Filter], Error> in
            let header = ["Authorization": token.value]
            let urlString = "\(URL.Host.moneyHistory)/money/categories"
            return HTTPClient.shared.request(urlString: urlString, headers: header)
        }
        .eraseToAnyPublisher()
    }

}
