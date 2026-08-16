//
//  OnboardingViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 08/05/2025.
//

import Foundation

class OnboardingViewModel {
    weak var coordinator: AuthCoordinator?

    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }
    
    func goToLogin() {
        coordinator?.goToLoginPage()
    }
}
