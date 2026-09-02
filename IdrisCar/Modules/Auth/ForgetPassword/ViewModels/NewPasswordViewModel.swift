//
//  NewPasswordViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 08/05/2025.
//

import Foundation
import Combine

class NewPasswordViewModel: ObservableObject {
    
    var cancellables: Set<AnyCancellable> = []
    
    @Published var passwordText = ""
    
    @Published var passwordEyeOn = true
    
    @Published var confirmPasswordText = ""
    
    @Published var confirmPasswordEyeOn = true
    
    @Published var errorMessage: String? = nil
    
    @Published var isAnimating = false
    
    // MARK: - Validation Errors
    @Published var validationErrors: [String: [String]] = [:]
    
    let phoneNumber: String
    let dataService: RegistrationRepository
    weak var coordinator: AuthCoordinator?

    init(phoneNumber: String, dataService: RegistrationRepository = RemoteRegistrationRepository(), coordinator: AuthCoordinator) {
        self.phoneNumber = phoneNumber
        self.dataService = dataService
        self.coordinator = coordinator
    }
    
    func switchPasswordEye(){
        self.passwordEyeOn.toggle()
    }
    
    func switchConfirmPasswordEye(){
        self.confirmPasswordEyeOn.toggle()
    }
    
    func showPasswordChanged() {
        guard validateInputs() else { return }
        
        errorMessage = nil
        isAnimating = true
        
        dataService.resetPassword(request: ResetPasswordAPIRequest(
            phoneNumber: phoneNumber,
            password: passwordText,
            passwordConfirmation: confirmPasswordText))
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Publisher stopped observing")
                case .failure(let error):
                    self.isAnimating = false
                    if let apiError = error as? APIError,
                       case .validation(let message, let errors) = apiError {
                        self.validationErrors = errors
                        self.errorMessage = self.formattedValidationMessage(message: message, errors: errors)
                    } else {
                        self.errorMessage = String(format: "Failed to reset password: %@".localized, error.localizedDescription)
                    }
                }
            },
            receiveValue: { response in
                self.isAnimating = false
                if response.success {
                    self.coordinator?.showPasswordChanged()
                } else {
                    self.errorMessage = "Failed to reset password. Please try again.".localized
                }
            }
        )
        .store(in: &cancellables)
    }
    
    private func validateInputs() -> Bool {
        if passwordText.isEmpty {
            errorMessage = "Please enter your new password.".localized
            return false
        }
        
        if confirmPasswordText.isEmpty {
            errorMessage = "Please confirm your new password.".localized
            return false
        }
        
        if passwordText.count < 8 {
            errorMessage = "Password must be at least 8 characters.".localized
            return false
        }
        
        if passwordText != confirmPasswordText {
            errorMessage = "New password and confirmation do not match.".localized
            return false
        }
        
        errorMessage = nil
        return true
    }
    
    private func formattedValidationMessage(message: String, errors: [String: [String]]) -> String {
        let validationMessages = errors.keys.sorted().flatMap { errors[$0] ?? [] }
        return validationMessages.isEmpty ? message : validationMessages.joined(separator: "\n")
    }
}
