//
//  CarsAPIRequest.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 22/05/2025.
//

import Foundation

struct CarsAPIRequest: Encodable {
    var name: String?
    var brandId: Int?
    var modelId: Int?
    var versionId: Int?
    var bodyTypeId: Int?
    var priceFrom: Int?
    var priceTo: Int?
    var sortBy: String?
    
    init(name: String? = nil, brandId: Int? = nil, modelId: Int? = nil, versionId: Int? = nil, bodyTypeId: Int? = nil, priceFrom: Int? = nil, priceTo: Int? = nil, sortBy: String? = nil) {
        self.name = name
        self.brandId = brandId
        self.modelId = modelId
        self.versionId = versionId
        self.bodyTypeId = bodyTypeId
        self.priceFrom = priceFrom
        self.priceTo = priceTo
        self.sortBy = sortBy
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case brandId = "brand_id"
        case modelId = "model_id"
        case versionId = "version_id"
        case bodyTypeId = "body_type_id"
        case priceFrom = "price_from"
        case priceTo = "price_to"
        case sortBy = "sort_by"
    }
}
