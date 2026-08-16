//
//  CheckOTPAPIRequest.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 06/05/2025.
//

import Foundation

// MARK: - CheckOTPAPIRequest
struct CheckOTPAPIRequest: Codable {
    let phoneNumber, otp: String

    enum CodingKeys: String, CodingKey {
        case phoneNumber = "phone_number"
        case otp
    }
}
