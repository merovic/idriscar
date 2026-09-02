//
//  ContactUsTextViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 18/06/2025.
//

import Foundation
import Combine

class ContactUsTextViewModel: ObservableObject {
    
    var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var websiteInfo: WebsiteInfoAPIResponse?
    
    @Published var errorMessage =  ""
    @Published var isAnimating = false
        
    let dataRepository: ProfileRepository
    weak var coordinator: ProfileCoordinator?
    
    init(dataRepository: ProfileRepository = RemoteProfileRepository(), coordinator: ProfileCoordinator?) {
        self.coordinator = coordinator
        self.dataRepository = dataRepository
        self.getContactUs()
    }
    
    func popView(){
        guard let coordinator = coordinator else { return }
        coordinator.popView()
    }
    
    func getContactUs() {
        
        self.isAnimating = true
        
        dataRepository.getWebsiteInfo()
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
                self.websiteInfo = response.data
            }
        )
        .store(in: &cancellables)
    }
}

