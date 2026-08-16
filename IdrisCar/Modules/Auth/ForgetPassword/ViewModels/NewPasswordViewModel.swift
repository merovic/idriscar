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
    
    weak var coordinator: AuthCoordinator?

    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }
    
    func switchPasswordEye(){
        self.passwordEyeOn.toggle()
    }
    
    func switchConfirmPasswordEye(){
        self.confirmPasswordEyeOn.toggle()
    }
    
    func showPasswordChanged() {
        coordinator?.showPasswordChanged()
    }
}
