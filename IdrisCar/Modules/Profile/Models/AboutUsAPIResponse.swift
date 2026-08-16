//
//  AboutUsAPIResponse.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 18/06/2025.
//

import Foundation

// MARK: - AboutUsAPIResponse
struct AboutUsAPIResponse: Codable {
    let id: Int
    let name: String
    let image: String
    let description: String?
}

extension AboutUsAPIResponse: Equatable {}
