//
//  WebsiteInfoAPIResponse.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 18/06/2025.
//

import Foundation

// MARK: - WebsiteInfoAPIResponse
struct WebsiteInfoAPIResponse: Codable {
    let siteName, siteLogo, siteLogoFooter: String
    let siteDescription, copyright, supportEmailTop, supportPhoneTop: String
    let workingHours: [WorkingHour]
    let mobileNumbers: [MobileNumber]
    let emails: [Email]
    let address: String
    let location: [Location]
    let socialNetwork: SocialNetwork

    enum CodingKeys: String, CodingKey {
        case siteName = "site_name"
        case siteLogo = "site_logo"
        case siteLogoFooter = "site_logo_footer"
        case siteDescription = "site_description"
        case copyright
        case supportEmailTop = "support_email_top"
        case supportPhoneTop = "support_phone_top"
        case workingHours = "working_hours"
        case mobileNumbers = "mobile_numbers"
        case emails, address, location
        case socialNetwork = "social_network"
    }
}

extension WebsiteInfoAPIResponse: Equatable {}

// MARK: - Email
struct Email: Codable {
    let email: String
}

extension Email: Equatable {}

// MARK: - Location
struct Location: Codable {
    let zoom, latitude, longitude: String
}

extension Location: Equatable {}

// MARK: - MobileNumber
struct MobileNumber: Codable {
    let mobile: String
}

extension MobileNumber: Equatable {}

// MARK: - SocialNetwork
struct SocialNetwork: Codable {
    let tiktok: String?
    let youtube: String?
    let facebook: String?
    let linkedin, whatsapp: String?
    let instagram: String?
    let pinterest, xTwitter: String?

    enum CodingKeys: String, CodingKey {
        case tiktok, youtube, facebook, linkedin, whatsapp, instagram, pinterest
        case xTwitter = "x_twitter"
    }
}

extension SocialNetwork: Equatable {}

// MARK: - WorkingHour
struct WorkingHour: Codable {
    let hours: String
}

extension WorkingHour: Equatable {}
