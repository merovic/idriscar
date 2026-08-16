//
//  OffersViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 27/03/2025.
//

import Foundation
import Combine

class OffersViewModel: ObservableObject {
    
    var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var offers: [Offer] = []
    
    @Published var selectedOfferID: Int?
    
    @Published var isBackButtonVisible: Bool?
        
    @Published var isAnimating = false
    
    //---------------------
    
    let dataRepository: OffersRepository
    weak var coordinator: OffersCoordinator?
    
    init(dataRepository: OffersRepository = RemoteOffersRepository(), coordinator: OffersCoordinator?, isBackButtonVisible: Bool? = false) {
        self.coordinator = coordinator
        self.dataRepository = dataRepository
        self.isBackButtonVisible = isBackButtonVisible
    }
    
    func pop(){
        coordinator?.popView()
    }
    
    func goToOfferDetails(){
        coordinator?.goToOfferDetails(offerID: String(selectedOfferID ?? 0))
    }
    
    func getOffers() {
        guard offers.isEmpty else {
            return
        }
        
        self.isAnimating = true

        dataRepository.getOffers()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        print("Publisher stopped observing")
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.isAnimating = false
                    }
                },
                receiveValue: { response in
                    self.isAnimating = false
                    self.offers = response.data?.data ?? []
                }
            )
            .store(in: &cancellables)
    }
}

