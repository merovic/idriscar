//
//  ForgetPasswordViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 08/05/2025.
//

import Foundation
import Combine

class ForgetPasswordViewModel: ObservableObject {
    
    var cancellables: Set<AnyCancellable> = []
    
    @Published var phoneNumber = ""
    @Published var errorMessage =  ""
    @Published var isAnimating = false
    
    // MARK: - Validation Errors
    @Published var validationErrors: [String: [String]] = [:]
    
    let dataService: RegistrationRepository
    weak var coordinator: AuthCoordinator?

    init(dataService: RegistrationRepository = RemoteRegistrationRepository(), coordinator: AuthCoordinator) {
        self.dataService = dataService
        self.coordinator = coordinator
    }
    
    func goToEnterOTP() {
        coordinator?.goToEnterOTP(phoneText: phoneNumber, isForgetPassword: true)
    }
    
    func sendOTP() {
        self.isAnimating = true
        dataService.sendSMSForget(request: SendSMSRequest(phoneNumber: phoneNumber))
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { (completion) in
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
                            self.errorMessage = error.localizedDescription
                        }
                    }
                },
                receiveValue: { response in
                    self.isAnimating = false
                    if response.success{
                        self.goToEnterOTP()
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    private func formattedValidationMessage(message: String, errors: [String: [String]]) -> String {
        let validationMessages = errors.keys.sorted().flatMap { errors[$0] ?? [] }
        return validationMessages.isEmpty ? message : validationMessages.joined(separator: "\n")
    }
}
