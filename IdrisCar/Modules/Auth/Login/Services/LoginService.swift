//
//  LoginService.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 06/05/2025.
//

import Foundation
import Combine

protocol LoginRepository {
    func getIntroVideo() -> AnyPublisher<BaseResponse<IntroVideoAPIResponse>, Error>
    func login(request: LoginAPIRequest) -> AnyPublisher<BaseResponse<LoginAPIResponse>, Error>
}

class RemoteLoginRepository: LoginRepository {
    func getIntroVideo() -> AnyPublisher<BaseResponse<IntroVideoAPIResponse>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.getIntroVideo)
    }
    
    func login(request: LoginAPIRequest) -> AnyPublisher<BaseResponse<LoginAPIResponse>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.login(request: request))
    }
}
