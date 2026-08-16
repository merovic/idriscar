//
//  HomeCoordinatorDelegate.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 17/05/2025.
//

protocol HomeCoordinatorDelegate: AnyObject {
    func navigateToOfferDetails(offerID: String?)
    func navigateToServiceDetails(serviceID: String?)
    func navigateToCars(brandID: String)
}
