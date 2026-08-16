//
//  EditProfileView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 04/06/2025.
//

import UIKit

class EditProfileView: UIViewController {
    
    var viewModel: EditProfileViewModel?
    
    private let loadingView = LoadingAnimation()
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindViews()
    }

    func BindViews(){
        guard let viewModel = viewModel else { return }
        
        viewModel.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &viewModel.cancellables)
        
        viewModel.$errorMessage
            .compactMap { $0.isEmpty ? nil : $0 }
            .sink { errorMessage in
                ToastManager.shared.showToast(
                    iconName: "erroricon",
                    titleText: "Edit Failed",
                    subtitleText: errorMessage,
                    hapticFeedback: .notification(type: .error)
                )
            }
            .store(in: &viewModel.cancellables)
        
        backButton.tapPublisher
            .sink {
                viewModel.popView()
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.$userData
            .sink { [weak self] user in
                guard let self = self else { return }
                firstNameTextField.text = user?.name
                lastNameTextField.text = user?.lastName
                emailTextField.text = user?.email
                phoneNumberTextField.text = user?.phoneNumber
            }
            .store(in: &viewModel.cancellables)
        
        firstNameTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.firstName, on: viewModel)
            .store(in: &viewModel.cancellables)
        
        lastNameTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.lastName, on: viewModel)
            .store(in: &viewModel.cancellables)
        
        emailTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.email, on: viewModel)
            .store(in: &viewModel.cancellables)
        
        phoneNumberTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.phoneNumber, on: viewModel)
            .store(in: &viewModel.cancellables)
        
        applyButton.tapPublisher
            .sink {
                viewModel.updateInfo()
            }
            .store(in: &viewModel.cancellables)
    }
    
}
