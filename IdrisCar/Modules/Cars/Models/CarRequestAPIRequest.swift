//
//  CarRequestAPIRequest.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 27/05/2025.
//

import Foundation

// MARK: - CarRequestAPIRequest
struct CarRequestAPIRequest: Codable {
    let carID: String
    let offerID: String?
    let services: [Int]
    let paymentType: String
    let salary, notes: String?
    
    init(carID: String, offerID: String? = nil, services: [Int], paymentType: String, salary: String? = nil, notes: String? = nil) {
        self.carID = carID
        self.offerID = offerID
        self.services = services
        self.paymentType = paymentType
        self.salary = salary
        self.notes = notes
    }

    enum CodingKeys: String, CodingKey {
        case carID = "car_id"
        case offerID = "offer_id"
        case services
        case paymentType = "payment_type"
        case salary, notes
    }
}
