//
//  EnterOTPViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 07/05/2025.
//

import Foundation
import Combine
import Firebase
import SwiftUI

class EnterOTPViewModel: ObservableObject {
    
    var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    var phoneText: String = ""
    var isForgetPassword: Bool = false
        
    @Published var codeText = ""
    @Published var errorMessage =  ""
    @Published var isAnimating = false
    private var didNavigateAfterOTP = false
        
    //---------------------
    
    let dataService: RegistrationRepository
    weak var coordinator: AuthCoordinator?
    
    init(phoneText:String, isForgetPassword:Bool, dataService: RegistrationRepository = RemoteRegistrationRepository(), coordinator: AuthCoordinator) {
        self.phoneText = phoneText
        self.isForgetPassword = isForgetPassword
        self.dataService = dataService
        self.coordinator = coordinator
    }
    
    func otpCheck() {
        guard !isAnimating else { return }

        if !codeText.isEmpty {
            self.isAnimating = true
            dataService.checkOTP(request: CheckOTPAPIRequest(phoneNumber: phoneText, otp: codeText))
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { [weak self] (completion) in
                        guard let self else { return }

                        switch completion {
                        case .finished:
                            print("Publisher stopped observing")
                        case .failure(let error):
                            self.isAnimating = false
                            errorMessage = error.localizedDescription
                        }
                    },
                    receiveValue: { [weak self] response in
                        guard let self else { return }

                        isAnimating = false
                        if response.success {
                            guard !didNavigateAfterOTP else { return }

                            didNavigateAfterOTP = true
                            DispatchQueue.main.async { [weak self] in
                                guard let self else { return }
                                if self.isForgetPassword {
                                    self.coordinator?.goToNewPasswordView(phoneNumber: self.phoneText)
                                } else {
                                    self.coordinator?.goToChooseTypeView(phoneNumber: self.phoneText)
                                }
                            }
                        }else{
                            errorMessage = response.message
                        }
                    }
                )
                .store(in: &cancellables)
        }else{
            self.errorMessage = "check_your_inputs_first".localized
        }
    }
    
    func sendOTP() {
        self.isAnimating = true
        dataService.sendSMS(request: SendSMSRequest(phoneNumber: phoneText))
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
                receiveValue: { response in
                    self.isAnimating = false
                }
            )
            .store(in: &cancellables)
    }
    
    func sendOTPForget() {
        self.isAnimating = true
        dataService.sendSMSForget(request: SendSMSRequest(phoneNumber: phoneText))
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
                receiveValue: { response in
                    self.isAnimating = false
                }
            )
            .store(in: &cancellables)
    }
        
}
