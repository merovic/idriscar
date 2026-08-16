//
//  CarFavoritesManager.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 23/06/2025.
//

import Foundation
import Combine

class CarFavoritesManager: ObservableObject {
    static let shared = CarFavoritesManager()
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published private(set) var favoriteCarIDs: Set<Int> = []
    
    private init() {}
    
    let dataRepository: CarsRepository = RemoteCarsRepository()
    
    let didToggleFavorite = PassthroughSubject<Int, Never>()

    func isFavorite(_ car: Car) -> Bool {
        favoriteCarIDs.contains(car.id)
    }

    func toggleFavorite(_ car: Car) {
        if isFavorite(car) {
            favoriteCarIDs.remove(car.id)
        } else {
            favoriteCarIDs.insert(car.id)
        }
        syncFavoritesToServer(carID: car.id)
        
        didToggleFavorite.send(car.id)
    }

    func setFavorites(from ids: [Int]) {
        let newSet = Set(ids)
        if newSet != favoriteCarIDs {
            favoriteCarIDs = newSet
        }
    }
    
    func removeAllFavorites() {
        favoriteCarIDs.removeAll()
        removeAllFavoritesFromAPI()
    }
    
    func syncFavoritesToServer(carID: Int) {
        dataRepository.toggleFavorite(request: AddToFavoriteAPIRequest(carID: carID))
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        print("Publisher stopped observing")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                },
                receiveValue: { response in
                }
            )
            .store(in: &cancellables)
    }
    
    func removeAllFavoritesFromAPI() {
        dataRepository.removeAllFavorite()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        print("Publisher stopped observing")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                },
                receiveValue: { response in
                }
            )
            .store(in: &cancellables)
    }
}
