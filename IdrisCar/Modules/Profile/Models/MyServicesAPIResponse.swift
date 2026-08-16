//
//  MyServicesAPIResponse.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 04/06/2025.
//

import Foundation

// MARK: - MyServicesAPIResponse
struct MyServicesAPIResponse: Codable {
    let data: [MyService]
    let links: Links
    let meta: Meta
}

extension MyServicesAPIResponse: Equatable {}

// MARK: - Datum
struct MyService: Codable {
    let id: Int
    @FlexibleInt var price: Int?
    let notes: String?
    let actionStatus: String?
    let service: Service

    enum CodingKeys: String, CodingKey {
        case id, price, notes
        case actionStatus = "action_status"
        case service
    }
}

extension MyService: Equatable {}
