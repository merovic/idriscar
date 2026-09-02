//
//  AppCoordinator.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 08/05/2025.
//

import Foundation
import UIKit

// MARK: - AppCoordinator

class AppCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showIntroVideo()
    }
    
    func showIntroVideo() {
        let introVideoView = IntroVideoView()
        introVideoView.onFinish = { [weak self] in
            guard let self = self else { return }
            if LoginDataService.shared.setFirstLaunchFromTermination() {
                self.showOnboardingView()
            } else if LoginDataService.shared.isLoggedIn() {
                self.showMainFlow()
            } else {
                self.showAuthFlow()
            }
        }
        navigationController.pushViewController(introVideoView, animated: true)
    }
    
    func showOnboardingView() {
        let onboardingView = OnboardingView()
        onboardingView.onFinish = { [weak self] in
            self?.showAuthFlow()
        }
        navigationController.pushViewController(onboardingView, animated: true)
    }

    func showAuthFlow() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator.parentCoordinator = self
        addChild(authCoordinator)
        authCoordinator.start()
    }

    func showMainFlow(lastCoordinator: Coordinator? = nil) {
        if lastCoordinator != nil {
            removeChild(lastCoordinator!)
        }
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        mainCoordinator.parentCoordinator = self
        addChild(mainCoordinator)
        mainCoordinator.start()
    }
    
    func showOffersFlow(lastCoordinator: Coordinator) {
        removeChild(lastCoordinator)
        let offersCoordinator = OffersCoordinator(navigationController: navigationController)
        offersCoordinator.parentCoordinator = self
        addChild(offersCoordinator)
        offersCoordinator.startWithBackButton()
    }
    
    func showOffersDetails(offerID: String) {
        let offersCoordinator = OffersCoordinator(navigationController: navigationController)
        offersCoordinator.parentCoordinator = self
        addChild(offersCoordinator)
        offersCoordinator.goToOfferDetails(offerID: offerID)
    }
    
    func showServicesFlow(lastCoordinator: Coordinator) {
        removeChild(lastCoordinator)
        let servicesCoordinator = ServicesCoordinator(navigationController: navigationController)
        servicesCoordinator.parentCoordinator = self
        addChild(servicesCoordinator)
        servicesCoordinator.startWithBackButton()
    }
    
    func showServiceDetails(serviceID: String) {
        let servicesCoordinator = ServicesCoordinator(navigationController: navigationController)
        servicesCoordinator.parentCoordinator = self
        addChild(servicesCoordinator)
        servicesCoordinator.goToServiceDetails(serviceID: serviceID)
    }
    
    func showCarsFlow(brandID: String) {
        let carsCoordinator = CarsCoordinator(navigationController: navigationController)
        carsCoordinator.parentCoordinator = self
        addChild(carsCoordinator)
        carsCoordinator.startWithBrand(brandID: brandID)
    }

    func addChild(_ coordinator: Coordinator) {
        children.append(coordinator)
    }

    func removeChild(_ coordinator: Coordinator) {
        children.removeAll { $0 === coordinator }
    }
}

extension AppCoordinator: HomeCoordinatorDelegate {
    func navigateToCars(brandID: String) {
        showCarsFlow(brandID: brandID)
    }
    
    func navigateToOfferDetails(offerID: String?) {
        showOffersDetails(offerID: offerID ?? "")
    }
    
    func navigateToServiceDetails(serviceID: String?) {
        showServiceDetails(serviceID: serviceID ?? "")
    }
}

extension AppCoordinator: AppCoordinatorDelegate {
    func didRequestLogout() {
        children.removeAll()
        showAuthFlow()
    }
    
    func didRequestChangeLanguage() {
        if let sceneDelegate = UIApplication.shared.connectedScenes
            .compactMap({ $0.delegate as? SceneDelegate })
            .first {
            sceneDelegate.restartApp()
        } else {
            LanguageManager.shared.applyLanguageSettings()
            navigationController.view.semanticContentAttribute = LanguageManager.shared.semanticContentAttribute
            navigationController.navigationBar.semanticContentAttribute = LanguageManager.shared.semanticContentAttribute
            children.removeAll()
            navigationController.setViewControllers([], animated: false)
            showIntroVideo()
        }
    }
}
