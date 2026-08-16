//
//  RequestServiceAPIRequest.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 20/05/2025.
//

import Foundation

// MARK: - RequestServiceAPIRequest
struct RequestServiceAPIRequest: Codable {
    let serviceID, notes: String

    enum CodingKeys: String, CodingKey {
        case serviceID = "service_id"
        case notes
    }
}
