//
//  AppLanguage.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 06/05/2025.
//

import Foundation

// MARK: - AppLanguage
struct AppLanguage: Codable, Identifiable {
    var id = UUID().uuidString
    let name, code: String
    
    init(name: String, code: String) {
        self.name = name
        self.code = code
    }
}
