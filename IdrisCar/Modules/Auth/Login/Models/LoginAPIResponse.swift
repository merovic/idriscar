//
//  LoginAPIResponse.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 05/05/2025.
//

import Foundation

// MARK: - LoginAPIResponse
struct LoginAPIResponse: Codable {
    let token: String
    var user: User
}

extension LoginAPIResponse: Equatable {}

// MARK: - User
struct User: Codable {
    let id: Int
    var name, lastName, email: String
    let companyName, companyEmail: String?
    let isCompany: String
    var phoneNumber: String
    let address: String?
    let cityID: String
    let contactOptions: [String]

    enum CodingKeys: String, CodingKey {
        case id, name
        case lastName = "last_name"
        case email
        case companyName = "company_name"
        case companyEmail = "company_email"
        case isCompany = "is_company"
        case phoneNumber = "phone_number"
        case address
        case cityID = "city_id"
        case contactOptions = "contact_options"
    }
}

extension User: Equatable {}
