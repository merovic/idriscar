//
//  DropDownAPIRequests.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 27/05/2025.
//

import Foundation

struct DropDownAPIRequests: Encodable {
    var brandId: Int?
    var modelId: Int?
    
    init(brandId: Int? = nil, modelId: Int? = nil) {
        self.brandId = brandId
        self.modelId = modelId
    }
    
    enum CodingKeys: String, CodingKey {
        case brandId = "brand_id"
        case modelId = "model_id"
    }
}
