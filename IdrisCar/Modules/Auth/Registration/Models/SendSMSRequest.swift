//
//  SendSMSRequest.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 05/05/2025.
//

import Foundation

// MARK: - SendSMSRequest
struct SendSMSRequest: Codable {
    let phoneNumber: String

    enum CodingKeys: String, CodingKey {
        case phoneNumber = "phone_number"
    }
}
