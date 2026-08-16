//
//  APIRouter.swift
//  APIRouter
//
//  Created by Amir Ahmed on 11/12/2023.
//

import Foundation

enum APIRouter: URLRequestConvertible {
    
    case getIntroVideo
    case register(request: RegisterationAPIRequest)
    case login(request: LoginAPIRequest)
    case sendSMS(request: SendSMSRequest)
    case sendSMSForget(request: SendSMSRequest)
    case checkOTP(request: CheckOTPAPIRequest)
    case forgetPassword(request: ResetPasswordAPIRequest)
    
    case getHome
    case getNotifications
    
    case getServices
    case getService(serviceID: String)
    case requestService(request: RequestServiceAPIRequest)
    
    case getOffers
    case getOffer(offerID: String)
    
    case getBrands
    case getBrand(brandID: String)
    
    case getCars(request: CarsAPIRequest)
    case getCar(carID: String)
    
    case requestCarDropDowns(request: DropDownAPIRequests)
    case requestCar(request: CarRequestAPIRequest)
    
    case changePassword(request: ChangePasswordAPIRequest)
    case changeInfo(request: ChangeInfoAPIRequest)
    case getCarRequests
    case getServiceRequest
    case getWishList
    
    case addToFavorite(request: AddToFavoriteAPIRequest)
    case removeAllFavorites
    case contactUs(request: ContactUsAPIRequest)
    
    case getTerms
    case getFAQ
    case getWebsiteInfo
    case getAboutUs
        
    // MARK: - RequestParameterMethod
    private var requestParameter: RequestParameterMethod? {
        switch self {
        case .getIntroVideo, .getHome, .getNotifications, .getServices, .getOffers, .getBrands, .getCarRequests, .getServiceRequest, .getWishList, .getTerms, .getFAQ, .getWebsiteInfo, .getAboutUs, .removeAllFavorites:
            return .none
        case .getCars, .requestCarDropDowns:
            return .queryParam
        case .register, .login, .sendSMS, .sendSMSForget, .checkOTP, .forgetPassword, .requestService, .requestCar, .addToFavorite, .changePassword, .changeInfo, .contactUs:
            return .formParam
        case .getService, .getOffer, .getBrand, .getCar:
            return .pathParam
        }
    }
    
    // MARK: - contentType
    private var contentType: String {
        switch self {
        case .getIntroVideo, .getHome, .getNotifications, .register, .login, .sendSMS, .sendSMSForget, .checkOTP, .forgetPassword, .getServices, .getService, .getOffers, .getOffer, .getBrands, .getBrand, .getCars, .getCar, .requestService, .requestCarDropDowns, .requestCar, .getCarRequests, .getServiceRequest, .getWishList, .addToFavorite, .changePassword, .changeInfo, .contactUs, .getTerms, .getFAQ, .getWebsiteInfo, .getAboutUs, .removeAllFavorites:
            return ContentType.json.rawValue
        }
    }
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .getIntroVideo, .getHome, .getNotifications, .getServices, .getService, .getOffers, .getOffer, .getBrands, .getBrand, .getCars, .getCar, .requestCarDropDowns, .getCarRequests, .getServiceRequest, .getWishList, .getTerms, .getFAQ, .getWebsiteInfo, .getAboutUs:
            return .get
        case .register, .login, .sendSMS, .sendSMSForget, .checkOTP, .forgetPassword, .requestService, .requestCar, .addToFavorite, .changePassword, .changeInfo, .contactUs, .removeAllFavorites:
            return .post
        }
    }
    
    // MARK: - EndPoint
    private var endpoint: String {
        switch self {
        case .getIntroVideo, .getHome, .getNotifications, .register, .login, .sendSMS, .sendSMSForget, .checkOTP, .forgetPassword, .getServices, .getService, .getOffers, .getOffer, .getBrands, .getBrand, .getCars, .getCar, .requestService, .requestCarDropDowns, .requestCar, .getCarRequests, .getServiceRequest, .getWishList, .addToFavorite, .changePassword, .changeInfo, .contactUs, .getTerms, .getFAQ, .getWebsiteInfo, .getAboutUs, .removeAllFavorites:
            return RemoteServers.ProductionServer.value
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .getIntroVideo:
            return "intro-video"
        case .getHome:
            return "homepage"
        case .getNotifications:
            return "notifications"
        case .register:
            return "register"
        case .login:
            return "login"
        case .sendSMS:
            return "otp/send-sms"
        case .sendSMSForget:
            return "otp/user-need-action-send"
        case .checkOTP:
            return "otp/check-otp"
        case .forgetPassword:
            return "reset-password"
        case .getServices:
            return "services"
        case .getService(serviceID: let serviceID):
            return "services/" + serviceID
        case .getOffers:
            return "offers"
        case .getOffer(offerID: let offerID):
            return "offers/" + offerID
        case .getBrands:
            return "brands"
        case .getBrand(brandID: let brandID):
            return "brands/" + brandID
        case .getCars:
            return "cars"
        case .getCar(carID: let carID):
            return "cars/" + carID
        case .requestService:
            return "service-request"
        case .requestCarDropDowns:
            return "car-request/dropdowns"
        case .requestCar:
            return "car-request"
        case .changePassword:
            return "user/change-password"
        case .changeInfo:
            return "user/change-info"
        case .getCarRequests:
            return "car-request"
        case .getServiceRequest:
            return "service-request"
        case .getWishList:
            return "favorite"
        case .addToFavorite:
            return "favorite"
        case .contactUs:
            return "contact"
        case .getTerms:
            return "page/terms"
        case .getFAQ:
            return "page/faq"
        case .getWebsiteInfo:
            return "website-info"
        case .getAboutUs:
            return "page/about-us"
        case .removeAllFavorites:
            return "favorite/remove-all"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .getIntroVideo:
            return nil
        case .getHome:
            return nil
        case .getNotifications:
            return nil
        case .register(request: let request):
            return request.dictionary
        case .login(request: let request):
            return request.dictionary
        case .sendSMS(request: let request):
            return request.dictionary
        case .sendSMSForget(request: let request):
            return request.dictionary
        case .checkOTP(request: let request):
            return request.dictionary
        case .forgetPassword(request: let request):
            return request.dictionary
        case .getServices:
            return nil
        case .getService:
            return nil
        case .getOffers:
            return nil
        case .getOffer:
            return nil
        case .getBrands:
            return nil
        case .getBrand:
            return nil
        case .getCars(request: let request):
            return request.dictionary
        case .getCar:
            return nil
        case .requestService(request: let request):
            return request.dictionary
        case .requestCarDropDowns(request: let request):
            return request.dictionary
        case .requestCar(request: let request):
            return request.dictionary
        case .changePassword(request: let request):
            return request.dictionary
        case .changeInfo(request: let request):
            return request.dictionary
        case .getCarRequests:
            return nil
        case .getServiceRequest:
            return nil
        case .getWishList:
            return nil
        case .addToFavorite(request: let request):
            return request.dictionary
        case .contactUs(request: let request):
            return request.dictionary
        case .getTerms:
            return nil
        case .getFAQ:
            return nil
        case .getWebsiteInfo:
            return nil
        case .getAboutUs:
            return nil
        case .removeAllFavorites:
            return nil
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let fullURL = URL(string: endpoint)!.appendingPathComponent(path)
        var urlComponents = URLComponents(url: fullURL, resolvingAgainstBaseURL: true)
        var urlRequest = URLRequest(url: fullURL)
        
        // HTTPMethod
        urlRequest.httpMethod = method.rawValue
        
        // Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        if let token = LoginDataService.shared.getUserData()?.token {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        }
        urlRequest.setValue(LanguageManager.shared.currentLocaleIdentifier, forHTTPHeaderField: "current-lang")
        
        // Parameters
        switch requestParameter {
        case .queryParam:
            if let parameters = parameters {
                urlComponents?.queryItems = parameters!.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            }
        case .pathParam:
            break
        case .formParam:
            if let parameters = parameters {
                do {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters!, options: [])
                } catch {
                    throw error
                }
            }
        case .none:
            break
        }
        
        guard let finalURL = urlComponents?.url else {
            fatalError("Failed to construct URL with parameters")
        }
        urlRequest.url = finalURL
        
        return urlRequest
    }
}
