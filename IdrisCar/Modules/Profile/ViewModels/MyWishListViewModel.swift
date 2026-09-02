//
//  MyWishListViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 04/06/2025.
//

import Foundation
import Combine

class MyWishListViewModel: ObservableObject {
    
    var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var wishList: [Car] = []
    
    @Published var errorMessage =  ""
    @Published var isAnimating = false
            
    let dataRepository: ProfileRepository
    weak var coordinator: ProfileCoordinator?
    
    init(dataRepository: ProfileRepository = RemoteProfileRepository(), coordinator: ProfileCoordinator?) {
        self.coordinator = coordinator
        self.dataRepository = dataRepository
        self.getWishList()
    }
    
    func popView(){
        guard let coordinator = coordinator else { return }
        coordinator.popView()
    }
    
    func goToRequestCar(carID: Int){
        guard let coordinator = coordinator else { return }
        coordinator.goToCarDetails(carID: carID, offerID: nil)
    }
    
    func removeAll(){
        guard let coordinator = coordinator else { return }
        CarFavoritesManager.shared.removeAllFavorites()
        coordinator.popView()
    }
    
    func getWishList() {
        
        self.isAnimating = true
        
        dataRepository.getWishList()
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { (completion) in
                switch completion {
                case .finished:
                    print("Publisher stopped observing")
                case .failure(let error):
                    self.isAnimating = false
                    self.errorMessage = error.localizedDescription
                }
            },
            receiveValue: { [self] response in
                self.isAnimating = false
                self.wishList = response.data?.data ?? []
                
                let favoriteIDs = self.wishList.filter { $0.isFavorite ?? false }.map { $0.id }
                CarFavoritesManager.shared.setFavorites(from: favoriteIDs)
            }
        )
        .store(in: &cancellables)
    }
}

