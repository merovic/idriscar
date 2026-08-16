//
//  NotificationsAPIResponse.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 19/06/2026.
//

import Foundation

// MARK: - NotificationsAPIResponse
struct NotificationsAPIResponse: Codable {
    let currentPage: Int
    let data: [NotificationModel]
    let firstPageURL: String
    let from, lastPage: Int
    let lastPageURL: String
    let links: [Link]
    let path: String
    let perPage: Int
    let to, total: Int

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case links
        case path
        case perPage = "per_page"
        case to, total
    }
}

extension NotificationsAPIResponse: Equatable {}

// MARK: - Datum
struct NotificationModel: Codable {
    let id, title, body: String
    let data: NotificationPayload
    let read: Bool
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, title, body, data, read
        case createdAt = "created_at"
    }
}

extension NotificationModel: Equatable {}

// MARK: - DataClass
struct NotificationPayload: Codable {
    let service, car, offer, brand: String
    let image: String
}

extension NotificationPayload: Equatable {}
