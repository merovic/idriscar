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
    
    func checkForPhone(phone: String) -> String{
        let phoneCode = "+966"
        let fCode = phoneCode.replacingOccurrences(of: "+", with: "")
        if !phone.starts(with: "0"){
            return fCode + phone
        }else{
            return fCode + phone.dropFirst()
        }
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
                    case .failure(_):
                        self.isAnimating = false
                        self.errorMessage = "Invalid credentials"
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
}
