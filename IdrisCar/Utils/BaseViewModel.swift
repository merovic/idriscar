//
//  BaseViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 08/05/2025.
//

import Combine
import Foundation

protocol BaseViewModelProtocal {
    func showIndicator()
    func hideIndicator()
    func showSomethingError()
    func showErrorAlert(error: String?)
    func showSuccessAlert(message: String?)
    func showLoginAlert(complation: @escaping () -> Void)
    func showDeleteAlert(complation: @escaping () -> Void)
    func showLogoutAlert(complation: @escaping () -> Void)
    func showInternetConnectionErrorAlert(completion: @escaping (() -> Void))
}

//class BaseViewModel: BaseViewModelProtocal {
//    init() { }
//
//    func showIndicator() {
//        LottieAppIndicator.shared.show(isGif: true)
//    }
//
//    func hideIndicator() {
//        LottieAppIndicator.shared.dismiss()
//    }
//
//    func showErrorAlert(error: String?) {
//        AppAlert.showErrorAlert(error: error)
//    }
//
//    func showSuccessAlert(message: String?) {
//        AppAlert.showSuccessAlert(message: message)
//    }
//
//    func showSomethingError() {
//        AppAlert.showSomethingError()
//    }
//}
