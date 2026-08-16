//
//  FlexibleInt.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 15/08/2026.
//

@propertyWrapper
struct FlexibleInt: Codable, Equatable {
    var wrappedValue: Int?

    init(wrappedValue: Int? = nil) {
        self.wrappedValue = wrappedValue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            wrappedValue = nil
            return
        }

        if let value = try? container.decode(Int.self) {
            wrappedValue = value
            return
        }

        if let value = try? container.decode(String.self) {
            wrappedValue = Int(value.trimmingCharacters(in: .whitespacesAndNewlines))
            return
        }

        wrappedValue = nil
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

@propertyWrapper
struct FlexibleString: Codable, Equatable {
    var wrappedValue: String?

    init(wrappedValue: String? = nil) {
        self.wrappedValue = wrappedValue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            wrappedValue = nil
            return
        }

        if let value = try? container.decode(String.self) {
            wrappedValue = value
            return
        }

        if let value = try? container.decode(Int.self) {
            wrappedValue = String(value)
            return
        }

        if let value = try? container.decode(Double.self) {
            wrappedValue = String(value)
            return
        }

        if let value = try? container.decode(Bool.self) {
            wrappedValue = String(value)
            return
        }

        wrappedValue = nil
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

@propertyWrapper
struct FlexibleBool: Codable, Equatable {
    var wrappedValue: Bool?

    init(wrappedValue: Bool? = nil) {
        self.wrappedValue = wrappedValue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            wrappedValue = nil
            return
        }

        if let value = try? container.decode(Bool.self) {
            wrappedValue = value
            return
        }

        if let value = try? container.decode(Int.self) {
            wrappedValue = value != 0
            return
        }

        if let value = try? container.decode(String.self) {
            switch value
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()
            {
            case "true", "1", "yes":
                wrappedValue = true

            case "false", "0", "no":
                wrappedValue = false

            default:
                wrappedValue = nil
            }

            return
        }

        wrappedValue = nil
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
