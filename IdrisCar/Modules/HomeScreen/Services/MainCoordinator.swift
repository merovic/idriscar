//
//  MainCoordinator.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 17/05/2025.
//

import UIKit

// MARK: - MainCoordinator

protocol TabBarNavigatable: AnyObject {
    func switchToTab(index: Int)
}

class MainCoordinator: Coordinator, TabBarNavigatable {
    weak var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    var tabBarController: HomeTabBarViewController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func switchToTab(index: Int) {
        tabBarController?.selectedIndex = index
    }

    func start() {
        // Create nav controllers
        let homeNav = UINavigationController()
        let carsNav = UINavigationController()
        let offersNav = UINavigationController()
        let servicesNav = UINavigationController()
        let profileNav = UINavigationController()

        // Create coordinators
        let homeCoordinator = HomeCoordinator(navigationController: homeNav)
        let carsCoordinator = CarsCoordinator(navigationController: carsNav)
        let offersCoordinator = OffersCoordinator(navigationController: offersNav)
        let servicesCoordinator = ServicesCoordinator(navigationController: servicesNav)
        let profileCoordinator = ProfileCoordinator(navigationController: profileNav)

        // Set specialProperties
        homeCoordinator.tabBarNavigator = self
        homeCoordinator.specialCasesNavigator = parentCoordinator as? HomeCoordinatorDelegate
        profileCoordinator.appCoordinator = parentCoordinator as? AppCoordinatorDelegate
        
        // Set parentCoordinator
        homeCoordinator.parentCoordinator = self
        carsCoordinator.parentCoordinator = self
        offersCoordinator.parentCoordinator = self
        servicesCoordinator.parentCoordinator = self
        profileCoordinator.parentCoordinator = self

        // Start each tab's flow (important!)
        homeCoordinator.start()
        carsCoordinator.start()
        offersCoordinator.start()
        servicesCoordinator.start()
        profileCoordinator.start()

        // Track them
        (parentCoordinator as? AppCoordinator)?.addChild(homeCoordinator)
        (parentCoordinator as? AppCoordinator)?.addChild(carsCoordinator)
        (parentCoordinator as? AppCoordinator)?.addChild(offersCoordinator)
        (parentCoordinator as? AppCoordinator)?.addChild(servicesCoordinator)
        (parentCoordinator as? AppCoordinator)?.addChild(profileCoordinator)

        // Setup the tab bar with loaded nav controllers
        self.tabBarController = HomeTabBarViewController(tabs: [
            homeNav, carsNav, offersNav, servicesNav, profileNav
        ])
        self.tabBarController?.coordinator = self

        navigationController.setViewControllers([self.tabBarController!], animated: true)
    }
}
