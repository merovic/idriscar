//
//  LoginViewModel.swift
//  IdrisCar
//
//  Created by Amir Morsy on 26/02/2025.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    
    var cancellables: Set<AnyCancellable> = []
    
    //---------------------
                    
    @Published var phoneText = ""
    
    @Published var emailText = ""
    
    @Published var passwordText = ""
    
    @Published var passwordEyeOn = true
    
    @Published var canLogin = false
    
    @Published var errorMessage: String? = nil
                
    @Published var isAnimating = false
    
    // MARK: - Validation Errors
    @Published var validationErrors: [String: [String]] = [:]
        
    //---------------------
        
    private let dataService: LoginRepository
    weak var coordinator: AuthCoordinator?
    
    init(dataService: LoginRepository = RemoteLoginRepository(), coordinator: AuthCoordinator) {
        self.dataService = dataService
        self.coordinator = coordinator
    }
    
    func goToHomeScreen(){
        coordinator?.goToHomeScreen()
    }
    
    func goToSignUp(){
        coordinator?.goToRegistration()
    }
    
    func goToForgetPassword(){
        coordinator?.goToForgetPassword()
    }
    
    func login() {
        
        self.isAnimating = true
        
        dataService.login(request: LoginAPIRequest(login: phoneText, password: passwordText))
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
                    if response.success {
                        LoginDataService.shared.setLogin()
                        LoginDataService.shared.setUserData(response.data!)
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            self.goToHomeScreen()
                        }
                    }
                }
            )
            .store(in: &cancellables)

    }
    
    func switchPasswordEye(){
        self.passwordEyeOn.toggle()
    }
    
    private func formattedValidationMessage(message: String, errors: [String: [String]]) -> String {
        let validationMessages = errors.keys.sorted().flatMap { errors[$0] ?? [] }
        return validationMessages.isEmpty ? message : validationMessages.joined(separator: "\n")
    }
}
