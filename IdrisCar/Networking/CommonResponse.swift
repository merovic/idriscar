//
//  CommonResponse.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 03/03/2025.
//

import Foundation

// MARK: - BaseResponse
public struct BaseResponse<T: Codable>: Codable, Equatable where T: Equatable {
    public var success: Bool
    public var statusCode: Int
    public var message: String
    public var data: T?
    
    public init(success: Bool, statusCode: Int, message: String, data: T? = nil) {
        self.success = success
        self.statusCode = statusCode
        self.message = message
        self.data = data
    }
    
    public static func == (lhs: BaseResponse<T>, rhs: BaseResponse<T>) -> Bool {
        return lhs.success == rhs.success && lhs.statusCode == rhs.statusCode && lhs.message == rhs.message && lhs.data == rhs.data
    }
    
    public enum CodingKeys: String, CodingKey {
        case success = "success"
        case statusCode = "status_code"
        case message = "message"
        case data = "data"
    }
}
