//
//  BrandsService.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 17/05/2025.
//

import Foundation
import Combine

protocol BrandsRepository {
    func getBrands() -> AnyPublisher<BaseResponse<BrandsAPIResponse>, Error>
    func getBrand(brandID: String) -> AnyPublisher<BaseResponse<Brand>, Error>
}

class RemoteBrandsRepository: BrandsRepository {
    func getBrands() -> AnyPublisher<BaseResponse<BrandsAPIResponse>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.getBrands)
    }
    
    func getBrand(brandID: String) -> AnyPublisher<BaseResponse<Brand>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.getBrand(brandID: brandID))
    }
}
