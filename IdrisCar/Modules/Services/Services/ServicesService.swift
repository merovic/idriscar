//
//  ServicesService.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 16/05/2025.
//

import Foundation
import Combine

protocol ServicesRepository {
    func getServices() -> AnyPublisher<BaseResponse<ServicesAPIResponse>, Error>
    func getService(serviceID: String) -> AnyPublisher<BaseResponse<Service>, Error>
    func requestService(request: RequestServiceAPIRequest) -> AnyPublisher<BaseResponse<[String]>, Error>
}

class RemoteServicesRepository: ServicesRepository {
    func getServices() -> AnyPublisher<BaseResponse<ServicesAPIResponse>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.getServices)
    }
    
    func getService(serviceID: String) -> AnyPublisher<BaseResponse<Service>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.getService(serviceID: serviceID))
    }
    
    func requestService(request: RequestServiceAPIRequest) -> AnyPublisher<BaseResponse<[String]>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.requestService(request: request))
    }
}
