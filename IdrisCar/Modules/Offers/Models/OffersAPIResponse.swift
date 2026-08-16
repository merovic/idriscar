//
//  OffersAPIResponse.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 16/05/2025.
//

import Foundation

// MARK: - OffersAPIResponse
struct OffersAPIResponse: Codable {
    let data: [Offer]
    let links: Links
    let meta: Meta
}

extension OffersAPIResponse: Equatable {}

// MARK: - Datum
struct Offer: Codable {
    let id: Int
    let name: String
    let image: String
    let slug: String
    let summary: String?
    let imageCover: String?
    let description: String?
    let releatedCars: [Car]?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case image
        case slug
        case summary
        case imageCover = "image_cover"
        case description
        case releatedCars = "cars"
    }
}

extension Offer: Equatable {}
