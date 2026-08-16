//
//  CreateAccountView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 01/03/2025.
//

import UIKit
import Combine

class CreateAccountView: UIViewController {
    
    private let loadingView = LoadingAnimation()
    
    var viewModel: CreateAccountViewModel!

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindViews()
    }
    
    func BindViews(){
        viewModel.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &viewModel.cancellables)
        
        viewModel.$errorMessage
            .dropFirst()
            .compactMap { $0 }
            .sink { errorMessage in
                ToastManager.shared.showToast(
                    iconName: "erroricon",
                    titleText: "Registration Failed",
                    subtitleText: errorMessage,
                    hapticFeedback: .notification(type: .error)
                )
            }
            .store(in: &viewModel.cancellables)
        
        backButton.tapPublisher
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &viewModel.cancellables)
        
        phoneNumberTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.phoneNumber, on: viewModel)
            .store(in: &viewModel.cancellables)
    }
    
    @IBAction func continueClicked(_ sender: Any) {
        if viewModel.phoneNumber.isEmpty {
            ToastManager.shared.showToast(
                iconName: "erroricon",
                titleText: "Registration Failed",
                subtitleText: "The phone number field is required.",
                hapticFeedback: .notification(type: .error)
            )
        } else {
            viewModel.sendOTP()
        }
    }
}
