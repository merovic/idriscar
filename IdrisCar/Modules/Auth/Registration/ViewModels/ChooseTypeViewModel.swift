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
    
    weak var coordinator: AuthCoordinator?

    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }
    
    func goToCompleteRegistration() {
        coordinator?.goToCompleteRegistration(isCompany: registrationType == .company)
    }
}

enum RegistrationType: Identifiable {
    case company, individual
    var id: Int {
        self.hashValue
    }
}
