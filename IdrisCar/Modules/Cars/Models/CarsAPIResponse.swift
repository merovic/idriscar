//
//  CarsAPIResponse.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 17/05/2025.
//

import Foundation

// MARK: - CarsAPIResponse
struct CarsAPIResponse: Codable {
    let data: [Car]
    let links: Links
    let meta: Meta
}

extension CarsAPIResponse: Equatable {}
