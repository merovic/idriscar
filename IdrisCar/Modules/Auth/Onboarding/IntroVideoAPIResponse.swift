//
//  IntroVideoAPIResponse.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 29/04/2026.
//

import Foundation

// MARK: - IntroVideoAPIResponse
struct IntroVideoAPIResponse: Codable {
    let id: Int
    let name: String?
    let youtubeURL: String?
    let youtubeID: String?
    let video: String?
    let image: String?
    let description, priority: String?

    enum CodingKeys: String, CodingKey {
        case id, name, image
        case youtubeURL = "youtube_url"
        case youtubeID = "youtube_id"
        case video, description, priority
    }
}

extension IntroVideoAPIResponse: Equatable {}
