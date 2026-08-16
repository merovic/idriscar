//
//  HomeAPIResponse.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 03/03/2025.
//

import Foundation
import SwiftUI

// MARK: - HomeAPIResponse

// MARK: - DataClass
struct HomeAPIResponse: Codable {
    let slideshow: [HomeModel]
    let brands: [Brand]
    let cars: [Car]
    let agencyInformation: [HomeModel]
    let services: [Service]
    let banks: [HomeModel]
    let finances: [HomeModel]
    let offers: [Offer]
    let clients, testimonials: [HomeModel]

    enum CodingKeys: String, CodingKey {
        case slideshow, brands, cars
        case agencyInformation = "agency_information"
        case services, banks, finances, offers, clients, testimonials
    }
}

extension HomeAPIResponse: Equatable {}

// MARK: - HomeModel
struct HomeModel: Codable {
    let id: Int
    let name, image: String?
    let description: String?
    let slug: String?
    let summary: String?
}

extension HomeModel: Equatable {}

// MARK: - Car
struct Car: Codable {
    let id: Int
    let name: String
    let image: String
    let slug: String
    @FlexibleInt var year: Int?
    @FlexibleInt var price: Int?
    @FlexibleString var oldPrice: String?
    @FlexibleString var installmentStartsFrom: String?
    @FlexibleInt var brandID: Int?
    let brand, model, version: String
    let bodyType, statusSticker: String
    @FlexibleBool var isFavorite: Bool?
    @FlexibleBool var isPriceHide: Bool?
    @FlexibleBool var isRequestButtonHide: Bool?
    let imageCover: String?
    let description: String?
    let albums: [Album]?
    let colors: [ColorItem]?
    let featuresGroups: [FeaturesGroup]?

    enum StatusSticker: Codable, Equatable {
        case availableUponRequest
        case new
        case unknown

        init(from apiValue: String) {
            switch apiValue.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
            case "available upon request", "يتوفر عند الطلب":
                self = .availableUponRequest

            case "new", "جديد":
                self = .new

            default:
                self = .unknown
            }
        }

        var color: Color {
            switch self {
            case .availableUponRequest:
                return Color(red: 139/255, green: 0, blue: 0) // dark red
                
            case .new:
                return .green
                
            case .unknown:
                return .clear
            }
        }
    }
    
    var stickerStatus: StatusSticker {
        StatusSticker(from: statusSticker)
    }

    enum CodingKeys: String, CodingKey {
        case id, name, image, slug, year, price
        case oldPrice = "old_price"
        case installmentStartsFrom = "installment_starts_from"
        case brandID = "brand_id"
        case brand, model, version
        case bodyType = "body_type"
        case statusSticker = "status_sticker"
        case isFavorite = "is_favorite"
        case isPriceHide = "is_price_hide"
        case isRequestButtonHide = "is_request_button_hide"
        case imageCover = "image_cover"
        case description, albums, colors
        case featuresGroups = "features_groups"
    }
}

extension Car: Equatable {}

// MARK: - Service
struct Service: Codable {
    let id: Int
    let name, image, slug: String
    let summary: String?
    @FlexibleInt var price: Int?
    @FlexibleInt var oldPrice: Int?
    @FlexibleBool var isPriceHide: Bool?
    @FlexibleBool var isRequestButtonHide: Bool?
    let imageCover: String?
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id, name, image, slug, summary, price
        case oldPrice = "old_price"
        case isPriceHide = "is_price_hide"
        case isRequestButtonHide = "is_request_button_hide"
        case imageCover = "image_cover"
        case description
    }
}

extension Service: Equatable {}


// MARK: - Album
struct Album: Codable {
    let name: String
    let description: String?
    let images: [ImageItem]
}

extension Album: Equatable {}

// MARK: - ImageItem
struct ImageItem: Codable {
    let image: String
    let name: String?
    let description: String?
}

extension ImageItem: Equatable {}

// MARK: - Color
struct ColorItem: Codable, Identifiable {
    let id = UUID()
    let color, image: String
    
    enum CodingKeys: String, CodingKey {
        case color
        case image
    }
}

extension ColorItem: Equatable {}

// MARK: - FeaturesGroup
struct FeaturesGroup: Codable, Identifiable {
    let id = UUID()
    let groupName: String
    let features: [Feature]

    enum CodingKeys: String, CodingKey {
        case groupName = "group_name"
        case features
    }
}

extension FeaturesGroup: Equatable {}

// MARK: - Feature
struct Feature: Codable, Identifiable {
    var id = UUID()
    let name: String
    let value: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case value
    }
}

extension Feature: Equatable {}
