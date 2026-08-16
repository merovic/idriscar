//
//  RequestCarCoordinator.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 26/05/2025.
//

import Foundation
import UIKit
import BottomSheet

class RequestCarCoordinator: Coordinator, RequestBottomSheetDelegate {
    weak var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    var car: Car
    var offerID: Int?

    init(navigationController: UINavigationController, car: Car, offerID: Int? = nil) {
        self.navigationController = navigationController
        self.car = car
        self.offerID = offerID
    }

    func start() {
        let viewModel = RequestCarViewModel(coordinator: self, car: car, offerID: offerID)
        let requestCarVC = RequestCarView()
        requestCarVC.viewModel = viewModel
        navigationController.pushViewController(requestCarVC, animated: true)
    }
    
    func showWelcomeToIdris(){
        let vc = RequestSuccessView(initialHeight: 400)
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
    
    func goToHomeScreen() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func clickAssigned() {
        goToHomeScreen()
    }
}
