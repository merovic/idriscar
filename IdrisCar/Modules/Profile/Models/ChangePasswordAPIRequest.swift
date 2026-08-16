//
//  ChangePasswordAPIRequest.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 04/06/2025.
//

import Foundation

// MARK: - ChangePasswordAPIRequest
struct ChangePasswordAPIRequest: Codable {
    let password, passwordConfirmation: String

    enum CodingKeys: String, CodingKey {
        case password
        case passwordConfirmation = "password_confirmation"
    }
}
