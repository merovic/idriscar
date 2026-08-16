//
//  HomeCoordinator.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 19/05/2025.
//

import Foundation
import UIKit

class HomeCoordinator: BaseCoordinator, CarDetailsNavigatable {
    weak var tabBarNavigator: TabBarNavigatable?
    weak var specialCasesNavigator: HomeCoordinatorDelegate?
    
    override func start() {
        let vc = HomeScreenView()
        let viewModel = HomeViewModel(coordinator: self)
        viewModel.showOfferDetails = { [weak self] offerID in
            self?.specialCasesNavigator?.navigateToOfferDetails(offerID: offerID)
        }
        viewModel.showServiceDetails = { [weak self] serviceID in
            self?.specialCasesNavigator?.navigateToServiceDetails(serviceID: serviceID)
        }
        viewModel.showCarsWithBrand = { [weak self] brandID in
            self?.specialCasesNavigator?.navigateToCars(brandID: brandID)
        }
        vc.viewModel = viewModel
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func goToNotifications() {
        let newViewController = NotificationsView()
        newViewController.hidesBottomBarWhenPushed = true
        newViewController.viewModel = NotificationsViewModel(coordinator: self)
        navigationController.pushViewController(newViewController, animated: true)
    }
    
    func goToFilter() {
        let newViewController = FilterView()
        newViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(newViewController, animated: true)
    }
    
    func goToBrands() {
        let newViewController = BrandsView()
        let viewModel = BrandsViewModel(coordinator: self)
        viewModel.showCars = { [weak self] brandID in
            self?.specialCasesNavigator?.navigateToCars(brandID: brandID)
        }
        newViewController.viewModel = viewModel
        
        newViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(newViewController, animated: true)
    }
        
    func goToServicesTab() {
        tabBarNavigator?.switchToTab(index: 3)
    }
    
    func goToOffersTab() {
        tabBarNavigator?.switchToTab(index: 2)
    }
    
    func goToCarsTab() {
        tabBarNavigator?.switchToTab(index: 1)
    }
    
    deinit {
        print("HomeCoordinator Deinit")
    }
}
