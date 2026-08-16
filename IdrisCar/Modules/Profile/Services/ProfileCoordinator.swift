//
//  ProfileCoordinator.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 19/05/2025.
//

import Foundation
import UIKit

class ProfileCoordinator : BaseCoordinator, CarDetailsNavigatable {
    weak var appCoordinator: AppCoordinatorDelegate?
    
    override func start() {
        let profileView = ProfileView()
        profileView.viewModel = ProfileViewModel(coordinator: self)
        navigationController.setViewControllers([profileView], animated: false)
    }
    
    func goToEditProfile(){
        let vc = EditProfileView()
        vc.hidesBottomBarWhenPushed = true
        vc.viewModel = EditProfileViewModel(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToSecurityLogin(){
        let vc = SecurityLoginView()
        vc.hidesBottomBarWhenPushed = true
        vc.viewModel = SecurityLoginViewModel(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToCarRequests(){
        let vc = CarsReqestsView()
        vc.hidesBottomBarWhenPushed = true
        vc.viewModel = CarsReqestsViewModel(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToServicesRequests(){
        let vc = ServicesReqestsView()
        vc.hidesBottomBarWhenPushed = true
        vc.viewModel = ServicesReqestsViewModel(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToWishlist(){
        let vc = MyWishListView()
        vc.hidesBottomBarWhenPushed = true
        vc.viewModel = MyWishListViewModel(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToSendMessage(){
        let vc = ContactUsView()
        vc.hidesBottomBarWhenPushed = true
        vc.viewModel = ContactUsViewModel(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToAboutUsView(){
        let vc = AboutUsView()
        vc.hidesBottomBarWhenPushed = true
        vc.viewModel = AboutUsViewModel(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToTermsView(){
        let vc = TermsView()
        vc.hidesBottomBarWhenPushed = true
        vc.viewModel = TermsViewModel(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToFAQView(){
        let vc = FAQView()
        vc.hidesBottomBarWhenPushed = true
        vc.viewModel = FAQViewModel(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToContactUs(){
        let vc = ContactUsTextView()
        vc.hidesBottomBarWhenPushed = true
        vc.viewModel = ContactUsTextViewModel(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func popView(){
        navigationController.popViewController(animated: true)
    }
    
    func signOut() {
        if let coordinator = appCoordinator {
            coordinator.didRequestLogout()
        }else{
            print("Coordinator is NIL")
        }
    }
    
    func changeLanguage() {
        if let coordinator = appCoordinator {
            coordinator.didRequestChangeLanguage()
        }else{
            print("Coordinator is NIL")
        }
    }
    
    deinit {
        print("ProfileCoordinator Deinit")
    }
}
