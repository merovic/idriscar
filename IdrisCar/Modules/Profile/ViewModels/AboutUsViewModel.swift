//
//  AboutUsViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 18/06/2025.
//

import Foundation
import Combine

class AboutUsViewModel: ObservableObject {
    
    var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var aboutUsList: [AboutUsAPIResponse] = []
    
    @Published var errorMessage =  ""
    @Published var isAnimating = false
        
    let dataRepository: ProfileRepository
    weak var coordinator: ProfileCoordinator?
    
    init(dataRepository: ProfileRepository = RemoteProfileRepository(), coordinator: ProfileCoordinator?) {
        self.coordinator = coordinator
        self.dataRepository = dataRepository
        self.getAboutUs()
    }
    
    func popView(){
        guard let coordinator = coordinator else { return }
        coordinator.popView()
    }
    
    func getAboutUs() {
        
        self.isAnimating = true
        
        dataRepository.getAboutUs()
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { (completion) in
                switch completion {
                case .finished:
                    print("Publisher stopped observing")
                case .failure(_):
                    self.isAnimating = false
                }
            },
            receiveValue: { [self] response in
                self.isAnimating = false
                self.aboutUsList = response.data ?? []
            }
        )
        .store(in: &cancellables)
    }
}
