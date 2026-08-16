//
//  ProfileViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 03/06/2025.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    
    var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var userModel: User?
    
    weak var coordinator: ProfileCoordinator?
    
    init(coordinator: ProfileCoordinator?) {
        self.coordinator = coordinator
        getUserInfo()
    }
    
    func getUserInfo() {
        self.userModel = LoginDataService.shared.getUserData()?.user
    }
    
    func goToEditProfile(){
        guard let coordinator = coordinator else { return }
        coordinator.goToEditProfile()
    }
    
    func goToSecurityLogin(){
        guard let coordinator = coordinator else { return }
        coordinator.goToSecurityLogin()
    }
    
    func goToCarsRequests(){
        guard let coordinator = coordinator else { return }
        coordinator.goToCarRequests()
    }
    
    func goToServicesRequests(){
        guard let coordinator = coordinator else { return }
        coordinator.goToServicesRequests()
    }
    
    func goToMyWishList(){
        guard let coordinator = coordinator else { return }
        coordinator.goToWishlist()
    }
    
    func goToContactUs(){
        guard let coordinator = coordinator else { return }
        coordinator.goToSendMessage()
    }
    
    func goToAboutUs(){
        guard let coordinator = coordinator else { return }
        coordinator.goToAboutUsView()
    }
    
    func goToTerms(){
        guard let coordinator = coordinator else { return }
        coordinator.goToTermsView()
    }
    
    func goToFAQ(){
        guard let coordinator = coordinator else { return }
        coordinator.goToFAQView()
    }
    
    func goToContactUsText(){
        guard let coordinator = coordinator else { return }
        coordinator.goToContactUs()
    }
    
    func signout(){
        LoginDataService.shared.setLogout()
        guard let coordinator = coordinator else { return }
        coordinator.signOut()
    }
    
    func changeLanguage(){
        guard let coordinator = coordinator else { return }
        coordinator.changeLanguage()
    }
}

