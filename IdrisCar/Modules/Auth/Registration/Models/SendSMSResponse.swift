//
//  SendSMSResponse.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 05/05/2025.
//

enum SendSMSAPIResponse: Codable {
    case stringValue(String)
    case errorDict([String: [String]])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let stringValue = try? container.decode(String.self) {
            self = .stringValue(stringValue)
        } else if let errorDict = try? container.decode([String: [String]].self) {
            self = .errorDict(errorDict)
        } else {
            throw DecodingError.typeMismatch(SendSMSAPIResponse.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Data type not matched"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .stringValue(let stringValue):
            try container.encode(stringValue)
        case .errorDict(let errorDict):
            try container.encode(errorDict)
        }
    }
}

extension SendSMSAPIResponse: Equatable {}
