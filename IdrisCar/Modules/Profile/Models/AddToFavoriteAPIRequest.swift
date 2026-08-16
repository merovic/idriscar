//
//  AddToFavoriteAPIRequest.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 05/06/2025.
//

import Foundation

// MARK: - AddToFavoriteAPIRequest
struct AddToFavoriteAPIRequest: Codable {
    let carID: Int

    enum CodingKeys: String, CodingKey {
        case carID = "car_id"
    }
}
