//
//  ServicesCoordinator.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 16/05/2025.
//

import Foundation
import UIKit
import BottomSheet

class ServicesCoordinator : Coordinator, ServicesBottomSheetDelegate {
    weak var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.isNavigationBarHidden = true
    }
    
    func start() {
        let servicesView = ServicesView()
        servicesView.viewModel = ServicesViewModel(coordinator: self)
        navigationController.setViewControllers([servicesView], animated: false)
    }
    
    func startWithBackButton() {
        let servicesView = ServicesView()
        servicesView.viewModel = ServicesViewModel(coordinator: self)
        navigationController.setViewControllers([servicesView], animated: false)
    }
    
    func popView(){
        navigationController.popViewController(animated: true)
    }
    
    func goToServiceDetails(serviceID: String){
        let serviceDetailsView = ServiceDetailsView()
        serviceDetailsView.viewModel = ServiceDetailsViewModel(serviceID: serviceID, coordinator: self)
        serviceDetailsView.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(serviceDetailsView, animated: true)
    }
    
    func showServiceSuccess(){
        let vc = ServiceSuccessView(initialHeight: 400)
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
    
    deinit {
        print("ServicesCoordinator Deinit")
    }
}
