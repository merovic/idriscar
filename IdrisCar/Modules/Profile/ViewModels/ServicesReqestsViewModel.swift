//
//  ServicesReqestsViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 04/06/2025.
//

import Foundation
import Combine

class ServicesReqestsViewModel: ObservableObject {
    
    var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var servicesRequests: [MyService] = []
    
    @Published var errorMessage =  ""
    @Published var isAnimating = false
        
    let dataRepository: ProfileRepository
    weak var coordinator: ProfileCoordinator?
    
    init(dataRepository: ProfileRepository = RemoteProfileRepository(), coordinator: ProfileCoordinator?) {
        self.coordinator = coordinator
        self.dataRepository = dataRepository
        self.getServicesRequests()
    }
    
    func popView(){
        guard let coordinator = coordinator else { return }
        coordinator.popView()
    }
    
    func getServicesRequests() {
        
        self.isAnimating = true
        
        dataRepository.getMyServices()
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
                self.servicesRequests = response.data?.data ?? []
            }
        )
        .store(in: &cancellables)
    }
}

