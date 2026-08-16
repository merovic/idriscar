//
//  TermsAPIResponse.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 18/06/2025.
//

import Foundation

// MARK: - TermsAPIResponse
struct TermsAPIResponse: Codable {
    let id: Int
    let name: String
    let image: String
    let description: String
}

extension TermsAPIResponse: Equatable {}
