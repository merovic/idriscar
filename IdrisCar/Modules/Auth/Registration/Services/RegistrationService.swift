//
//  RegistrationService.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 06/05/2025.
//

import Foundation
import Combine

protocol RegistrationRepository {
    func register(request: RegisterationAPIRequest) -> AnyPublisher<BaseResponse<LoginAPIResponse>, Error>
    func sendSMS(request: SendSMSRequest) -> AnyPublisher<BaseResponse<[String]>, Error>
    func sendSMSForget(request: SendSMSRequest) -> AnyPublisher<BaseResponse<[String]>, Error>
    func checkOTP(request: CheckOTPAPIRequest) -> AnyPublisher<BaseResponse<[String]>, Error>
    func resetPassword(request: ResetPasswordAPIRequest) -> AnyPublisher<BaseResponse<[String]>, Error>
}

class RemoteRegistrationRepository: RegistrationRepository {
    func register(request: RegisterationAPIRequest) -> AnyPublisher<BaseResponse<LoginAPIResponse>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.register(request: request))
    }
    
    func sendSMS(request: SendSMSRequest) -> AnyPublisher<BaseResponse<[String]>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.sendSMS(request: request))
    }
    
    func sendSMSForget(request: SendSMSRequest) -> AnyPublisher<BaseResponse<[String]>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.sendSMSForget(request: request))
    }
    
    func checkOTP(request: CheckOTPAPIRequest) -> AnyPublisher<BaseResponse<[String]>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.checkOTP(request: request))
    }
    
    func resetPassword(request: ResetPasswordAPIRequest) -> AnyPublisher<BaseResponse<[String]>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.forgetPassword(request: request))
    }
}
