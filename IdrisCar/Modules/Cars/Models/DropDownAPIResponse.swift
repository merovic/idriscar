//
//  DropDownAPIResponse.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 27/05/2025.
//

import Foundation

// MARK: - DropDownAPIResponse
struct DropDownAPIResponse: Codable {
    let services, brands: [FilterCommon]
    let models: [FilterModel]
    let versions: [FilterVersion]
    let bodyTypes: [BodyType]

    enum CodingKeys: String, CodingKey {
        case services, brands, models, versions
        case bodyTypes = "body_types"
    }
}

extension DropDownAPIResponse: Equatable {}

// MARK: - BodyType
struct BodyType: Codable {
    let id: Int
    let name: String
}

extension BodyType: Equatable {}

// MARK: - FilterCommon
struct FilterCommon: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
}

extension FilterCommon: Equatable {}

// MARK: - Model
struct FilterModel: Codable {
    let id: Int
    let name: String
    @FlexibleInt var brandID: Int?

    enum CodingKeys: String, CodingKey {
        case id, name
        case brandID = "brand_id"
    }
}

extension FilterModel: Equatable {}

// MARK: - Version
struct FilterVersion: Codable {
    let id: Int
    let name: String
    @FlexibleInt var modelID: Int?

    enum CodingKeys: String, CodingKey {
        case id, name
        case modelID = "model_id"
    }
}

extension FilterVersion: Equatable {}

extension BodyType {
    var asSelectionItem: SelectionItem {
        SelectionItem(id: self.id, name: self.name, filterID: "0")
    }
}

extension FilterCommon {
    var asSelectionItem: SelectionItem {
        SelectionItem(id: self.id, name: self.name, filterID: "0")
    }
}

extension FilterModel {
    var asSelectionItem: SelectionItem {
        SelectionItem(id: self.id, name: self.name, filterID: self.brandID.map(String.init))
    }
}

extension FilterVersion {
    var asSelectionItem: SelectionItem {
        SelectionItem(id: self.id, name: self.name, filterID: self.modelID.map(String.init))
    }
}
