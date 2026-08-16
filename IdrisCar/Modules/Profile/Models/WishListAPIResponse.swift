//
//  WishListAPIResponse.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 05/06/2025.
//

import Foundation

// MARK: - WishListAPIResponse
struct WishListAPIResponse: Codable {
    let data: [Car]
    let links: Links
    let meta: Meta
}

extension WishListAPIResponse: Equatable {}
