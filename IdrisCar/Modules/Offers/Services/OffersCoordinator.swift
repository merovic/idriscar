//
//  OffersCoordinator.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 19/05/2025.
//

import Foundation
import UIKit

class OffersCoordinator: BaseCoordinator, CarDetailsNavigatable {
    
    override func start() {
        let vc = OffersView()
        vc.viewModel = OffersViewModel(coordinator: self)
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func startWithBackButton() {
        let vc = OffersView()
        vc.viewModel = OffersViewModel(coordinator: self, isBackButtonVisible: true)
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func popView(){
        navigationController.popViewController(animated: true)
    }
    
    func goToOfferDetails(offerID: String) {
        let vc = OffersDetailsView()
        vc.viewModel = OfferDetailsViewModel(offerID: offerID, coordinator: self)
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    deinit {
        print("OffersCoordinator Deinit")
    }
}
