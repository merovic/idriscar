//
//  LoginAPIRequest.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 05/05/2025.
//

import Foundation

// MARK: - LoginAPIRequest
struct LoginAPIRequest: Codable {
    let login: String
    let password: String
    let deviceFcmToken: String = LoginDataService.shared.getFirebaseToken()

    enum CodingKeys: String, CodingKey {
        case login, password
        case deviceFcmToken = "device_fcm_token"
    }
}
