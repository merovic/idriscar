//
//  BrandsAPIResponse.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 17/05/2025.
//

import Foundation

// MARK: - BrandsAPIResponse
struct BrandsAPIResponse: Codable {
    let data: [Brand]
    let links: Links
    let meta: Meta
}

extension BrandsAPIResponse: Equatable {}

// MARK: - Brand
struct Brand: Codable, Identifiable {
    let id: Int
    let name: String
    let image: String
    let slug: String
}

extension Brand: Equatable {}
