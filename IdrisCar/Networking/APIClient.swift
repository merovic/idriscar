//
//  APIClient.swift
//  CombineNetworking
//
//  Created by Amir Ahmed on 11/12/2023.
//

import Foundation
import Combine

class APIClient {
    private static var cancellables: Set<AnyCancellable> = []
    
    @discardableResult
    static func performDecodableRequest<T>(route: APIRouter) -> AnyPublisher<T, Error> where T: Decodable {
        do {
            let urlRequest = try route.asURLRequest()
            return URLSession.shared.dataTaskPublisher(for: urlRequest)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .handleEvents(receiveOutput: { data, response in
                    if let responseString = String(data: data, encoding: .utf8) {
                        CustomPrint.swiftyAPIPrint(request: urlRequest, response: responseString, isDecodable: true)
                    }
                    CustomPrint.swiftyAPIPrintString(data: data)
                }, receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        CustomPrint.swiftyAPIPrintError(message: error.localizedDescription)
                    case .finished:
                        print("Request finished successfully.")
                    }
                })
                .tryMap { data, response -> Data in
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw APIError.invalidResponse
                    }

                    guard (200...299).contains(httpResponse.statusCode) else {
                        throw parseAPIError(from: data)
                    }

                    return data
                }
                .tryMap { data -> T in
                    do {
                        return try JSONDecoder().decode(T.self, from: data)
                    } catch let decodingError as DecodingError {
                        printDecodingError(decodingError, data: data)
                        throw decodingError
                    } catch {
                        throw error
                    }
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } catch {
            print("Request creation failed with error: \(error)")
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    private static func parseAPIError(from data: Data) -> APIError {
        do {
            let response = try JSONDecoder().decode(
                ValidationErrorResponse.self,
                from: data
            )

            return .validation(
                message: response.message,
                errors: response.data
            )

        } catch {
            return .invalidResponse
        }
    }
    
    private static func printDecodingError(_ error: DecodingError, data: Data) {
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Raw JSON:")
            print(jsonString)
        }

        switch error {
        case .typeMismatch(let type, let context):
            print("Type mismatch for type '\(type)' at \(context.codingPathString): \(context.debugDescription)")
        case .valueNotFound(let type, let context):
            print("Value not found for type '\(type)' at \(context.codingPathString): \(context.debugDescription)")
        case .keyNotFound(let key, let context):
            print("Key '\(key.stringValue)' not found at \(context.codingPathString): \(context.debugDescription)")
        case .dataCorrupted(let context):
            print("Data corrupted at \(context.codingPathString): \(context.debugDescription)")
        @unknown default:
            print("Unknown decoding error: \(error)")
        }
    }
}


private extension DecodingError.Context {
    var codingPathString: String {
        codingPath.map { $0.stringValue }.joined(separator: " -> ")
    }
}

struct ValidationErrorResponse: Decodable {
    let success: Bool
    let statusCode: Int?
    let message: String
    let data: [String: [String]]

    enum CodingKeys: String, CodingKey {
        case success
        case statusCode = "status_code"
        case message
        case data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        statusCode = try container.decodeIfPresent(Int.self, forKey: .statusCode)
        message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
        
        if let errors = try? container.decode(
            [String: [String]].self,
            forKey: .data
        ) {
            data = errors
        } else {
            data = [:]
        }
    }
}
