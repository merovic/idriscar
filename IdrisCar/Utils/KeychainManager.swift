//
//  KeychainManager.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 06/05/2025.
//

import Foundation
import Security

final class KeychainManager {
    
    static let shared = KeychainManager()
    
    private init() {}
    
    func save<T: Codable>(_ value: T, forKey key: String) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        
        let query: [String: Any] = [
            kSecClass as String             : kSecClassGenericPassword,
            kSecAttrAccount as String       : key,
            kSecValueData as String         : data
        ]
        
        SecItemDelete(query as CFDictionary) // Remove existing value if any
        SecItemAdd(query as CFDictionary, nil)
    }
    
    func get<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        let query: [String: Any] = [
            kSecClass as String             : kSecClassGenericPassword,
            kSecAttrAccount as String       : key,
            kSecReturnData as String        : true,
            kSecMatchLimit as String        : kSecMatchLimitOne
        ]
        
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess,
              let data = item as? Data,
              let value = try? JSONDecoder().decode(T.self, from: data) else {
            return nil
        }
        
        return value
    }
    
    func delete(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String             : kSecClassGenericPassword,
            kSecAttrAccount as String       : key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
