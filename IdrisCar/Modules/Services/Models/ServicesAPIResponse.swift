//
//  ServicesAPIResponse.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 16/05/2025.
//

import Foundation

// MARK: - ServicesAPIResponse
struct ServicesAPIResponse: Codable {
    let data: [Service]
    let links: Links
    let meta: Meta
}

extension ServicesAPIResponse: Equatable {}

// MARK: - Links
struct Links: Codable {
    let first, last: String
}

extension Links: Equatable {}

// MARK: - Meta
struct Meta: Codable {
    let currentPage: Int
    let from: Int?
    let lastPage: Int
    let links: [Link]
    let path: String
    let to: Int?
    let perPage, total: Int

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case from
        case lastPage = "last_page"
        case links, path
        case perPage = "per_page"
        case to, total
    }
}

extension Meta: Equatable {}

// MARK: - Link
struct Link: Codable {
    let url: String?
    let label: String
    let active: Bool
}

extension Link: Equatable {}
