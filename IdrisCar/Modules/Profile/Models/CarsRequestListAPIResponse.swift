//
//  CarsRequestListAPIResponse.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 04/06/2025.
//

import Foundation

// MARK: - CarsRequestListAPIResponse
struct CarsRequestListAPIResponse: Codable {
    let data: [CarsRequestItem]
    let links: Links
    let meta: Meta
}

extension CarsRequestListAPIResponse: Equatable {}

// MARK: - Datum
struct CarsRequestItem: Codable {
    let id: Int
    let paymentType: String
    let notes: String?
    @FlexibleInt var salary: Int?
    @FlexibleInt var price: Int?
    let actionStatus: String?
    let car: Car

    enum CodingKeys: String, CodingKey {
        case id, price, notes
        case paymentType = "payment_type"
        case salary
        case actionStatus = "action_status"
        case car
    }
}

extension CarsRequestItem: Equatable {}
