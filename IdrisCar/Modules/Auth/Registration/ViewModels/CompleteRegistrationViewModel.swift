//
//  CreateAccountViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 07/05/2025.
//

import Foundation
import Combine
import SwiftUI

class CompleteRegistrationViewModel: ObservableObject {
    
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Input Fields
    
    var isCompany: Bool
    
    @Published var companyName = ""
    @Published var companyEmail = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var phoneNumber = ""
    @Published var emailAddress = ""
    @Published var city = "Yanbu"
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isTermsAccepted = false
    @Published var contactOptions: [String] = []
    
    // MARK: - UI States
    
    @Published var isAnimating = false
    @Published var errorMessage: String? = nil
        
    // MARK: - Services
    
    let dataService: RegistrationRepository
    weak var coordinator: AuthCoordinator?
    
    // MARK: - Init
    
    init(isCompany: Bool, dataService: RegistrationRepository = RemoteRegistrationRepository(), coordinator: AuthCoordinator) {
        self.isCompany = isCompany
        self.dataService = dataService
        self.coordinator = coordinator
    }
    
    func showWelcomePopUp(){
        coordinator?.showWelcomeToIdris()
    }
    
    // MARK: - Signup
    
    func signup() {
        guard validateInputs() else { return }
        
        isAnimating = true
        
        let request = RegisterationAPIRequest(
            name: firstName,
            lastName: lastName,
            email: emailAddress,
            phoneNumber: phoneNumber,
            password: password,
            passwordConfirmation: confirmPassword,
            cityID: "1",
            isCompany: isCompany ? "1" : "0",
            companyName: companyName,
            companyEmail: companyEmail,
            contactOptions: contactOptions)
        
        dataService.register(request: request)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Signup publisher completed")
                    case .failure(let error):
                        self.isAnimating = false
                        self.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { response in
                    self.isAnimating = false
                    if response.success {
                        LoginDataService.shared.setUserData(response.data!)
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            self.showWelcomePopUp()
                        }
                    } else {
                        self.errorMessage = response.message
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Input Validation
    
    private func validateInputs() -> Bool {
        if isCompany {
            var emptyFields = [String]()
            
            if companyName.isEmpty { emptyFields.append("Company Name") }
            if companyEmail.isEmpty { emptyFields.append("Company Email") }
            if phoneNumber.isEmpty { emptyFields.append("Phone Number") }
            if city.isEmpty { emptyFields.append("City") }
            if password.isEmpty { emptyFields.append("Password") }
            if confirmPassword.isEmpty { emptyFields.append("Confirm Password") }
            
            if !emptyFields.isEmpty {
                errorMessage = "Please fill in: " + emptyFields.joined(separator: ", ")
                return false
            }
        } else {
            var emptyFields = [String]()
            
            if firstName.isEmpty { emptyFields.append("First Name") }
            if lastName.isEmpty { emptyFields.append("Last Name") }
            if phoneNumber.isEmpty { emptyFields.append("Phone Number") }
            if emailAddress.isEmpty { emptyFields.append("Email Address") }
            if city.isEmpty { emptyFields.append("City") }
            if password.isEmpty { emptyFields.append("Password") }
            if confirmPassword.isEmpty { emptyFields.append("Confirm Password") }
            
            if !emptyFields.isEmpty {
                errorMessage = "Please fill in: " + emptyFields.joined(separator: ", ")
                return false
            }
        }
        
        if !isTermsAccepted {
            errorMessage = "Please accept terms and conditions".localized
            return false
        }
        
        if password != confirmPassword {
            errorMessage = "Passwords do not match".localized
            return false
        }
        
        return true
    }
}
