//
//  TermsViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 18/06/2025.
//

import Foundation
import Combine

class TermsViewModel: ObservableObject {
    
    var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var terms: String = ""
    
    @Published var errorMessage =  ""
    @Published var isAnimating = false
        
    let dataRepository: ProfileRepository
    weak var coordinator: ProfileCoordinator?
    
    init(dataRepository: ProfileRepository = RemoteProfileRepository(), coordinator: ProfileCoordinator?) {
        self.coordinator = coordinator
        self.dataRepository = dataRepository
        self.getTerms()
    }
    
    func popView(){
        guard let coordinator = coordinator else { return }
        coordinator.popView()
    }
    
    func getTerms() {
        
        self.isAnimating = true
        
        dataRepository.getTerms()
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
                self.terms = response.data?.description ?? ""
            }
        )
        .store(in: &cancellables)
    }
}

