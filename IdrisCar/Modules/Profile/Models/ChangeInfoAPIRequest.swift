//
//  ChangeInfoAPIRequest.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 04/06/2025.
//

import Foundation

// MARK: - ChangeInfoAPIRequest
struct ChangeInfoAPIRequest: Codable {
    let name, lastName, email: String

    enum CodingKeys: String, CodingKey {
        case name
        case lastName = "last_name"
        case email
    }
}
