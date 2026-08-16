//
//  ServiceDetailsViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 16/05/2025.
//

import Foundation
import Combine

class ServiceDetailsViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var service: Service?
    @Published var serviceAddionalDetails: String = ""
    @Published var isAnimating = false
    
    //---------------------
    
    let dataRepository: ServicesRepository
    weak var coordinator: ServicesCoordinator?
    
    var serviceID: String
    
    init(dataRepository: ServicesRepository = RemoteServicesRepository(), serviceID: String, coordinator: ServicesCoordinator) {
        self.dataRepository = dataRepository
        self.serviceID = serviceID
        self.coordinator = coordinator
        self.getService()
    }
    
    func pop(){
        coordinator?.popView()
    }
    
    func showSuccessView(){
        coordinator?.showServiceSuccess()
    }
    
    func getService() {
        
        self.isAnimating = true

        dataRepository.getService(serviceID: serviceID)
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
                    self.service = response.data
                }
            )
            .store(in: &cancellables)
    }
    
    func requestService() {
        
        self.isAnimating = true

        dataRepository.requestService(request: RequestServiceAPIRequest(
            serviceID: serviceID,
            notes: serviceAddionalDetails))
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
                    if response.success{
                        self.showSuccessView()
                    }
                }
            )
            .store(in: &cancellables)
    }
}


