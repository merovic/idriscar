//
//  CarsCoordinator.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 19/05/2025.
//

import Foundation
import UIKit

class CarsCoordinator: BaseCoordinator, CarDetailsNavigatable {
    
    override func start() {
        let vc = CarsView()
        vc.viewModel = CarsViewModel(coordinator: self)
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func popView(){
        navigationController.popViewController(animated: true)
    }
    
    func startWithBackButton() {
        let vc = CarsView()
        vc.viewModel = CarsViewModel(coordinator: self, isBackButtonVisible: true)
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func startWithBrand(brandID: String){
        let vc = CarsView()
        vc.hidesBottomBarWhenPushed = true
        vc.viewModel = CarsViewModel(coordinator: self, brandID: brandID, isBackButtonVisible: true)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToFilter(onFilterApplied: @escaping (CarsAPIRequest) -> Void) {
        let vc = FilterView()
        let viewModel = FilterViewModel()
        vc.hidesBottomBarWhenPushed = true
        vc.viewModel = viewModel
        
        viewModel.onFilterCars = { carsRequest in
            onFilterApplied(carsRequest)
        }
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToComparison(){
        let vc = ComparisonView()
        vc.hidesBottomBarWhenPushed = true
        vc.viewModel = ComparisonViewModel()
        navigationController.pushViewController(vc, animated: true)
    }
    
    deinit {
        print("CarsCoordinator Deinit")
    }
}
