//
//  ServicesViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 27/03/2025.
//

import Foundation
import Combine

class ServicesViewModel: ObservableObject {
    
    var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var services: [Service] = []
    
    @Published var selectedServiceID: Int?
    
    @Published var isBackButtonVisible: Bool?
        
    @Published var isAnimating = false
    
    //---------------------
    
    let dataRepository: ServicesRepository
    weak var coordinator: ServicesCoordinator?
    
    init(dataRepository: ServicesRepository = RemoteServicesRepository(), coordinator: ServicesCoordinator?, isBackButtonVisible: Bool? = false) {
        self.dataRepository = dataRepository
        self.coordinator = coordinator
        self.isBackButtonVisible = isBackButtonVisible
    }
    
    func pop(){
        coordinator?.popView()
    }
    
    func showServiceDetails(){
        coordinator?.goToServiceDetails(serviceID: String(selectedServiceID ?? 0))
    }
    
    func getServices() {
        guard services.isEmpty else {
            return
        }
        
        self.isAnimating = true

        dataRepository.getServices()
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
                    self.services = response.data?.data ?? []
                }
            )
            .store(in: &cancellables)
    }
}


