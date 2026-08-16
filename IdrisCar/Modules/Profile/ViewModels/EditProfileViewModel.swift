//
//  EditProfileView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 04/06/2025.
//

import Foundation
import Combine

class EditProfileViewModel: ObservableObject {
    
    var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var userData: User?
                
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    
    @Published var errorMessage =  ""
    @Published var isAnimating = false
    
    let dataRepository: ProfileRepository
    weak var coordinator: ProfileCoordinator?
    
    init(dataRepository: ProfileRepository = RemoteProfileRepository(), coordinator: ProfileCoordinator?) {
        self.coordinator = coordinator
        self.dataRepository = dataRepository
        getUserInfo()
    }
    
    func popView(){
        guard let coordinator = coordinator else { return }
        coordinator.popView()
    }
    
    func getUserInfo() {
        guard let user = LoginDataService.shared.getUserData()?.user else { return }
        self.userData = user
        self.firstName = user.name
        self.lastName = user.lastName
        self.email = user.email
        self.phoneNumber = user.phoneNumber
    }
    
    func updateInfo() {
        if firstName.isEmpty {
            errorMessage = "Please enter your first name.".localized
            return
        }
        
        if lastName.isEmpty {
            errorMessage = "Please enter your last name.".localized
            return
        }
        
        if email.isEmpty {
            errorMessage = "Please enter your email address.".localized
            return
        }
        
        self.errorMessage = ""
        self.isAnimating = true
        
        dataRepository.changeInfo(request: ChangeInfoAPIRequest(
            name: firstName,
            lastName: lastName,
            email: email))
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { (completion) in
                switch completion {
                case .finished:
                    print("Publisher stopped observing")
                case .failure(let error):
                    self.isAnimating = false
                    self.errorMessage = String(format: "Failed to update profile: %@".localized, error.localizedDescription)
                }
            },
            receiveValue: { [self] response in
                self.isAnimating = false
                if response.success {
                    if var currentData = LoginDataService.shared.getUserData() {
                        currentData.user.name = firstName
                        currentData.user.lastName = lastName
                        currentData.user.email = email
                        currentData.user.phoneNumber = phoneNumber

                        LoginDataService.shared.setUserData(currentData)
                    }
                    
                    popView()
                } else {
                    errorMessage = "Failed to update profile. Please try again.".localized
                }
            }
        )
        .store(in: &cancellables)
    }
}
