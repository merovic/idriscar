//
//  ContactUsViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 05/06/2025.
//

import Foundation
import Combine

class ContactUsViewModel: ObservableObject {
    
    var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var subject: String = ""
    @Published var message: String = ""
    
    @Published var errorMessage = ""
    @Published var isAnimating = false
        
    let dataRepository: ProfileRepository
    weak var coordinator: ProfileCoordinator?
    
    init(dataRepository: ProfileRepository = RemoteProfileRepository(), coordinator: ProfileCoordinator?) {
        self.coordinator = coordinator
        self.dataRepository = dataRepository
    }
    
    func popView() {
        coordinator?.popView()
    }
    
    func sendMessage() {
        // Validation
        guard !fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Full name is required.".localized
            return
        }
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Email is required.".localized
            return
        }
        guard !subject.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Subject is required.".localized
            return
        }
        guard !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Message is required.".localized
            return
        }
        
        errorMessage = ""
        isAnimating = true
        
        dataRepository.contactUsMessage(request: ContactUsAPIRequest(
            name: fullName,
            email: email,
            phone: phone,
            subject: subject,
            message: message))
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    print("Publisher stopped observing")
                case .failure(let error):
                    self.isAnimating = false
                    self.errorMessage = "Failed to send message. Please try again.".localized
                    print("Error: \(error)")
                }
            },
            receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.isAnimating = false
                if response.success {
                    self.popView()
                } else {
                    self.errorMessage = "Failed to send message. Please try again.".localized
                }
            }
        )
        .store(in: &cancellables)
    }
}
