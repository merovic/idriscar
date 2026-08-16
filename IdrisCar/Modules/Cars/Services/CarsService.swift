//
//  CarsService.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 17/05/2025.
//

import Foundation
import Combine

protocol CarsRepository {
    func getCars(request: CarsAPIRequest) -> AnyPublisher<BaseResponse<CarsAPIResponse>, Error>
    func getBrands() -> AnyPublisher<BaseResponse<BrandsAPIResponse>, Error>
    func getCar(carID: String) -> AnyPublisher<BaseResponse<Car>, Error>
    func getRequestDropDowns(request: DropDownAPIRequests) -> AnyPublisher<BaseResponse<DropDownAPIResponse>, Error>
    func requestCar(request: CarRequestAPIRequest) -> AnyPublisher<BaseResponse<[String]>, Error>
    func toggleFavorite(request: AddToFavoriteAPIRequest) -> AnyPublisher<BaseResponse<[String]>, Error>
    func removeAllFavorite() -> AnyPublisher<BaseResponse<[String]>, Error>
}

class RemoteCarsRepository: CarsRepository {
    func removeAllFavorite() -> AnyPublisher<BaseResponse<[String]>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.removeAllFavorites)
    }
    
    func toggleFavorite(request: AddToFavoriteAPIRequest) -> AnyPublisher<BaseResponse<[String]>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.addToFavorite(request: request))
    }
    
    func requestCar(request: CarRequestAPIRequest) -> AnyPublisher<BaseResponse<[String]>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.requestCar(request: request))
    }
    
    func getRequestDropDowns(request: DropDownAPIRequests) -> AnyPublisher<BaseResponse<DropDownAPIResponse>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.requestCarDropDowns(request: request))
    }
    
    func getCars(request: CarsAPIRequest) -> AnyPublisher<BaseResponse<CarsAPIResponse>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.getCars(request: request))
    }
    
    func getBrands() -> AnyPublisher<BaseResponse<BrandsAPIResponse>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.getBrands)
    }
    
    func getCar(carID: String) -> AnyPublisher<BaseResponse<Car>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.getCar(carID: carID))
    }
}
