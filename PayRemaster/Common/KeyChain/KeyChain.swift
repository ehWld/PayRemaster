//
//  KeyChain.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/04/03.
//

import Foundation
import Security

class KeyChain {
    static let standard = KeyChain()
    
    private init() { }
    
    struct Errors: Error {
        let status: OSStatus
        
        init(_ status: OSStatus) {
            self.status = status
        }
    }
    
    func object<T: Codable>(forKey key: String) throws -> T? {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue as Any,
            kSecMatchLimit: kSecMatchLimitOne,
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
        if status == errSecSuccess {
            let decoder = JSONDecoder()
            let valueData = dataTypeRef as! Data
            let value = try decoder.decode(T.self, from: valueData)
            return value
        } else if status == errSecItemNotFound {
            return nil
        } else {
            throw KeyChain.Errors(status)
        }
    }
    
    func set<T: Codable>(_ value: T, forKey key: String) throws {
        let encoder = JSONEncoder()
        let valueData = try encoder.encode(value)
        
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: valueData
        ]
        
        SecItemDelete(query) // 이미 존재하는 경우 delete
        let status = SecItemAdd(query, nil)
        
        guard status == errSecSuccess else {
            throw KeyChain.Errors(status)
        }
    }
    
    func delete(forKey key: String) throws {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
        ]
        
        let status = SecItemDelete(query)
        guard status == errSecSuccess else {
            throw KeyChain.Errors(status)
        }
    }
    
}
