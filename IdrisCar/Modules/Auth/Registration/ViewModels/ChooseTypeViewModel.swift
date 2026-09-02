//
//  ChooseTypeViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 07/03/2025.
//

import Foundation
import Combine

class ChooseTypeViewModel: ObservableObject {
    
    var cancellables: Set<AnyCancellable> = []
    
    @Published var registrationType: RegistrationType = .individual
    
    var phoneNumber: String = ""
    
    weak var coordinator: AuthCoordinator?

    init(phoneNumber: String, coordinator: AuthCoordinator) {
        self.phoneNumber = phoneNumber
        self.coordinator = coordinator
    }
    
    func goToCompleteRegistration() {
        coordinator?.goToCompleteRegistration(phoneNumber: phoneNumber, isCompany: registrationType == .company)
    }
}

enum RegistrationType: Identifiable {
    case company, individual
    var id: Int {
        self.hashValue
    }
}
