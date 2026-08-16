//
//  LoadJSONFromLocal.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 25/03/2025.
//

import Foundation
import Combine

func loadJSONFromBundle<T: Decodable>(fileName: String, type: T.Type) -> AnyPublisher<T, Error> {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
        return Fail(error: URLError(.fileDoesNotExist)).eraseToAnyPublisher()
    }

    do {
        let data = try Data(contentsOf: url)
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return Just(decodedData)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    } catch {
        return Fail(error: error).eraseToAnyPublisher()
    }
}
