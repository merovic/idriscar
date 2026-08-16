//
//  ContactUsAPIRequest.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 05/06/2025.
//

import Foundation

// MARK: - ContactUsAPIRequest
struct ContactUsAPIRequest: Codable {
    let name, email, phone, subject: String
    let message: String
}
