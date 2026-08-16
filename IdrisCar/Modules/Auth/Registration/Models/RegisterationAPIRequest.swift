//
//  RegisterationAPIRequest.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 05/05/2025.
//

import Foundation

// MARK: - RegisterationAPIRequest
struct RegisterationAPIRequest: Codable {
    let name, lastName, email, phoneNumber: String
    let password, passwordConfirmation, cityID, isCompany: String
    let companyName, companyEmail: String
    let contactOptions: [String]
    let deviceFcmToken: String = LoginDataService.shared.getFirebaseToken()

    enum CodingKeys: String, CodingKey {
        case name
        case lastName = "last_name"
        case email
        case phoneNumber = "phone_number"
        case password
        case passwordConfirmation = "password_confirmation"
        case cityID = "city_id"
        case isCompany = "is_company"
        case companyName = "company_name"
        case companyEmail = "company_email"
        case contactOptions = "contact_options"
        case deviceFcmToken = "device_fcm_token"
    }
}
