//
//  HomeService.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 03/03/2025.
//

import Foundation
import Combine

protocol HomeRepository {
    func getHome() -> AnyPublisher<BaseResponse<HomeAPIResponse>, Error>
}

class RemoteHomeRepository: HomeRepository {
    func getHome() -> AnyPublisher<BaseResponse<HomeAPIResponse>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.getHome)
    }
}

class LocalHomeRepository: HomeRepository {
    func getHome() -> AnyPublisher<BaseResponse<HomeAPIResponse>, Error> {
        return loadJSONFromBundle(fileName: "homeScreenLocalResponse", type: BaseResponse<HomeAPIResponse>.self)
    }
}

class HomeService: HomeRepository {
    
    private let localRepo: LocalHomeRepository
    private let remoteRepo: RemoteHomeRepository

    init(localRepo: LocalHomeRepository = LocalHomeRepository(),
         remoteRepo: RemoteHomeRepository = RemoteHomeRepository()) {
        self.localRepo = localRepo
        self.remoteRepo = remoteRepo
    }
    
    func getHome() -> AnyPublisher<BaseResponse<HomeAPIResponse>, any Error> {
        return localRepo.getHome()
            .catch { _ in self.remoteRepo.getHome() }
            .eraseToAnyPublisher()
    }
}
