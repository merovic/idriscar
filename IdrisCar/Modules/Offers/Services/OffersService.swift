//
//  ServicesService.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 16/05/2025.
//

import Foundation
import Combine

protocol OffersRepository {
    func getOffers() -> AnyPublisher<BaseResponse<OffersAPIResponse>, Error>
    func getOffer(offerID: String) -> AnyPublisher<BaseResponse<Offer>, Error>
}

class RemoteOffersRepository: OffersRepository {
    func getOffers() -> AnyPublisher<BaseResponse<OffersAPIResponse>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.getOffers)
    }
    
    func getOffer(offerID: String) -> AnyPublisher<BaseResponse<Offer>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.getOffer(offerID: offerID))
    }
}
