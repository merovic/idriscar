//
//  SecurityLoginViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 04/06/2025.
//

import Foundation
import Combine

class SecurityLoginViewModel: ObservableObject {
    
    var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var oldPassword: String = ""
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var errorMessage =  ""
    @Published var isAnimating = false
    
    let dataRepository: ProfileRepository
    weak var coordinator: ProfileCoordinator?
    
    init(dataRepository: ProfileRepository = RemoteProfileRepository(), coordinator: ProfileCoordinator?) {
        self.coordinator = coordinator
        self.dataRepository = dataRepository
    }
    
    func popView(){
        guard let coordinator = coordinator else { return }
        coordinator.popView()
    }
    
    func updateInfo() {
        if oldPassword.isEmpty {
            errorMessage = "Please enter your old password.".localized
            return
        }
        
        if newPassword.isEmpty {
            errorMessage = "Please enter your new password.".localized
            return
        }
        
        if confirmPassword.isEmpty {
            errorMessage = "Please confirm your new password.".localized
            return
        }
        
        if newPassword != confirmPassword {
            errorMessage = "New password and confirmation do not match.".localized
            return
        }
        
        self.errorMessage = ""
        self.isAnimating = true
        
        dataRepository.changePassword(request: ChangePasswordAPIRequest(
            password: newPassword,
            passwordConfirmation: confirmPassword))
        
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { (completion) in
                switch completion {
                case .finished:
                    print("Publisher stopped observing")
                case .failure(let error):
                    self.isAnimating = false
                    self.errorMessage = String(format: "Failed to update profile: %@".localized, error.localizedDescription)
                }
            },
            receiveValue: { [self] response in
                self.isAnimating = false
                if response.success{
                    popView()
                } else {
                    errorMessage = "Failed to update profile. Please try again.".localized
                }
            }
        )
        .store(in: &cancellables)
    }
}
