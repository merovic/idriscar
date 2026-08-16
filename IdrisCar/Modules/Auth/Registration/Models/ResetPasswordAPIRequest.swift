//
//  ResetPasswordAPIRequest.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 06/05/2025.
//

import Foundation

// MARK: - ResetPasswordAPIRequest
struct ResetPasswordAPIRequest: Codable {
    let phoneNumber, password, passwordConfirmation: String

    enum CodingKeys: String, CodingKey {
        case phoneNumber = "phone_number"
        case password
        case passwordConfirmation = "password_confirmation"
    }
}
