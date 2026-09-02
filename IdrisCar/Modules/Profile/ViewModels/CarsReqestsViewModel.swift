//
//  CarsReqestsViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 05/06/2025.
//

import Foundation
import Combine

class CarsReqestsViewModel: ObservableObject {
    
    var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var carRequests: [CarsRequestItem] = []
    
    @Published var errorMessage =  ""
    @Published var isAnimating = false
        
    let dataRepository: ProfileRepository
    weak var coordinator: ProfileCoordinator?
    
    init(dataRepository: ProfileRepository = RemoteProfileRepository(), coordinator: ProfileCoordinator?) {
        self.coordinator = coordinator
        self.dataRepository = dataRepository
        self.getCarRequests()
    }
    
    func popView(){
        guard let coordinator = coordinator else { return }
        coordinator.popView()
    }
    
    func getCarRequests() {
        
        self.isAnimating = true
        
        dataRepository.getMyRequests()
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
                self.carRequests = response.data?.data ?? []
            }
        )
        .store(in: &cancellables)
    }
}

