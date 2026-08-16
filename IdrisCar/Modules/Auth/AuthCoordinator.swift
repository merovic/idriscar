//
//  AuthCoordinator.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 08/05/2025.
//

import Foundation
import UIKit
import BottomSheet

// MARK: - AuthCoordinator
class AuthCoordinator : Coordinator, AuthBottomSheetDelegate {
    weak var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.isNavigationBarHidden = true
    }
    
    func start() {
        goToLoginPage()
    }
    
    func goToOnboardingPage(){
        let onboardingView = OnboardingView()
        onboardingView.viewModel = OnboardingViewModel(coordinator: self)
        navigationController.setViewControllers([onboardingView], animated: false)
    }
        
    func goToLoginPage(){
        let loginView = LoginView()
        loginView.viewModel = LoginViewModel(coordinator: self)
        navigationController.setViewControllers([loginView], animated: false)
    }
    
    func goToEnterOTP(phoneText: String, isForgetPassword: Bool){
        let sendOTPView = EnterOTPRegistrationView()
        sendOTPView.viewModel = EnterOTPViewModel(phoneText: phoneText, isForgetPassword: isForgetPassword, coordinator: self)
        navigationController.pushViewController(sendOTPView, animated: true)
    }
    
    func goToChooseTypeView(){
        let chooseTypeView = ChooseTypeView()
        chooseTypeView.viewModel = ChooseTypeViewModel(coordinator: self)
        navigationController.pushViewController(chooseTypeView, animated: true)
    }
    
    func goToCompleteRegistration(isCompany: Bool){
        let completeRegistrationView = CompleteRegistrationView()
        completeRegistrationView.viewModel = CompleteRegistrationViewModel(isCompany: isCompany, coordinator: self)
        navigationController.pushViewController(completeRegistrationView, animated: true)
    }
    
    func showWelcomeToIdris(){
        let vc = WelcomeToIdrisView(initialHeight: 400)
        vc.delegate = self
        navigationController.presentBottomSheetInsideNavigationController(
            viewController: vc,
            configuration: BottomSheetConfiguration(
                cornerRadius: 20,
                pullBarConfiguration: .visible(.init(height: 20)),
                shadowConfiguration: .init(backgroundColor: UIColor.black.withAlphaComponent(0.6))
            )
        )
    }
    
    func showPasswordChanged(){
        let vc = PasswordChangedView(initialHeight: 400)
        vc.delegate = self
        navigationController.presentBottomSheetInsideNavigationController(
            viewController: vc,
            configuration: BottomSheetConfiguration(
                cornerRadius: 20,
                pullBarConfiguration: .visible(.init(height: 20)),
                shadowConfiguration: .init(backgroundColor: UIColor.black.withAlphaComponent(0.6))
            )
        )
    }
    
    func goToForgetPassword(){
        let forgetPasswordView = ForgetPasswordView()
        forgetPasswordView.viewModel = ForgetPasswordViewModel(coordinator: self)
        navigationController.pushViewController(forgetPasswordView, animated: true)
    }
    
    func goToNewPasswordView(){
        let newPasswordView = NewPasswordView()
        newPasswordView.viewModel = NewPasswordViewModel(coordinator: self)
        navigationController.pushViewController(newPasswordView, animated: true)
    }
    
    func goToRegistration(){
        let createAccountView = CreateAccountView()
        createAccountView.viewModel = CreateAccountViewModel(coordinator: self)
        navigationController.pushViewController(createAccountView, animated: true)
    }
    
    func goToHomeScreen() {
        (parentCoordinator as? AppCoordinator)?.showMainFlow(lastCoordinator: self)
    }
        
    func clickAssigned(page: BottomSheetPage) {
        switch page {
        case .newPassword:
            goToLoginPage()
        case .accountCreated:
            goToHomeScreen()
        }
    }
  
    deinit {
        print("AuthCoordinator Deinit")
    }
}
