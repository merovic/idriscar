//
//  OfferDetailsViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 20/05/2025.
//

import Foundation
import Combine

class OfferDetailsViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var offer: Offer?
    @Published var isAnimating = false
    
    //---------------------
    
    let dataRepository: OffersRepository
    weak var coordinator: OffersCoordinator?
    
    var offerID: String
    
    init(dataRepository: OffersRepository = RemoteOffersRepository(), offerID: String, coordinator: OffersCoordinator) {
        self.dataRepository = dataRepository
        self.offerID = offerID
        self.coordinator = coordinator
        self.getOffer()
    }
    func pop(){
        coordinator?.popView()
    }
    
    func showSuccessView(){
        //coordinator?.showServiceSuccess()
    }
    
    func getOffer() {
        
        self.isAnimating = true

        dataRepository.getOffer(offerID: offerID)
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
                    self.offer = response.data
                }
            )
            .store(in: &cancellables)
    }
    
//    func requestService() {
//        
//        self.isAnimating = true
//
//        dataRepository.requestService(request: RequestServiceAPIRequest(
//            serviceID: serviceID,
//            notes: serviceAddionalDetails))
//            .receive(on: DispatchQueue.main)
//            .sink(
//                receiveCompletion: { (completion) in
//                    switch completion {
//                    case .finished:
//                        print("Publisher stopped observing")
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                        self.isAnimating = false
//                    }
//                },
//                receiveValue: { response in
//                    self.isAnimating = false
//                    if response.success{
//                        self.showSuccessView()
//                    }
//                }
//            )
//            .store(in: &cancellables)
//    }
}


