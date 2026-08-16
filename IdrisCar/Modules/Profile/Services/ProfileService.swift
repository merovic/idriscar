//
//  ProfileService.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 05/06/2025.
//

import Foundation
import Combine

protocol ProfileRepository {
    func getMyServices() -> AnyPublisher<BaseResponse<MyServicesAPIResponse>, Error>
    func getMyRequests() -> AnyPublisher<BaseResponse<CarsRequestListAPIResponse>, Error>
    func getWishList() -> AnyPublisher<BaseResponse<WishListAPIResponse>, Error>
    func changePassword(request: ChangePasswordAPIRequest) -> AnyPublisher<BaseResponse<[String]>, Error>
    func changeInfo(request: ChangeInfoAPIRequest) -> AnyPublisher<BaseResponse<[String]>, Error>
    func contactUsMessage(request: ContactUsAPIRequest) -> AnyPublisher<BaseResponse<[String]>, Error>
    func getTerms() -> AnyPublisher<BaseResponse<TermsAPIResponse>, Error>
    func getWebsiteInfo() -> AnyPublisher<BaseResponse<WebsiteInfoAPIResponse>, Error>
    func getAboutUs() -> AnyPublisher<BaseResponse<[AboutUsAPIResponse]>, Error>
    func getFAQ() -> AnyPublisher<BaseResponse<FAQAPIResponse>, Error>
}

class RemoteProfileRepository: ProfileRepository {
    func getTerms() -> AnyPublisher<BaseResponse<TermsAPIResponse>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.getTerms)
    }
    
    func getWebsiteInfo() -> AnyPublisher<BaseResponse<WebsiteInfoAPIResponse>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.getWebsiteInfo)
    }
    
    func getAboutUs() -> AnyPublisher<BaseResponse<[AboutUsAPIResponse]>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.getAboutUs)
    }
    
    func getFAQ() -> AnyPublisher<BaseResponse<FAQAPIResponse>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.getFAQ)
    }
    
    func contactUsMessage(request: ContactUsAPIRequest) -> AnyPublisher<BaseResponse<[String]>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.contactUs(request: request))
    }
    
    func getMyServices() -> AnyPublisher<BaseResponse<MyServicesAPIResponse>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.getServiceRequest)
    }
    
    func getMyRequests() -> AnyPublisher<BaseResponse<CarsRequestListAPIResponse>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.getCarRequests)
    }
    
    func getWishList() -> AnyPublisher<BaseResponse<WishListAPIResponse>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.getWishList)
    }
    
    func changePassword(request: ChangePasswordAPIRequest) -> AnyPublisher<BaseResponse<[String]>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.changePassword(request: request))
    }
    
    func changeInfo(request: ChangeInfoAPIRequest) -> AnyPublisher<BaseResponse<[String]>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.changeInfo(request: request))
    }
}
