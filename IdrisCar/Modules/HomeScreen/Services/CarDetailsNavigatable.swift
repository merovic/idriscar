//
//  CarDetailsNavigatable.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 26/05/2025.
//

protocol CarDetailsNavigatable: AnyObject {
    func goToCarDetails(carID: Int, offerID: Int?)
    func startCarRequestFlow(for car: Car, and offerID: Int?)
}

extension CarDetailsNavigatable where Self: BaseCoordinator {
    func goToCarDetails(carID: Int, offerID: Int?) {
        let viewModel = CarDetailsViewModel(carID: carID)
        let carDetailsVC = CarDetailsView()
        carDetailsVC.viewModel = viewModel
        carDetailsVC.hidesBottomBarWhenPushed = true

        viewModel.onRequestCar = { [weak self] car in
            self?.startCarRequestFlow(for: car, and: offerID)
        }
        
        navigationController.pushViewController(carDetailsVC, animated: true)
    }

    func startCarRequestFlow(for car: Car, and offerID: Int?) {
        let requestCarCoordinator = RequestCarCoordinator(navigationController: navigationController, car: car, offerID: offerID)
        requestCarCoordinator.parentCoordinator = self
        children.append(requestCarCoordinator)
        requestCarCoordinator.start()
    }
}
