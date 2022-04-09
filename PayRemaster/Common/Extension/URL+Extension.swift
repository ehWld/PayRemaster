//
//  URL+Extension.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/04/02.
//

import Foundation

extension URL {
    struct Host {
        static let moneyHistory = "http://127.0.0.1:8080"
    }
    
    struct AppStore {
        static let payApp: URL = URL(string: "http://itunes.apple.com/app/id1464496236?mt=8")!
    }
}
