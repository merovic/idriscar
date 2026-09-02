//
//  SecurityLoginView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 04/06/2025.
//

import UIKit

class SecurityLoginView: UIViewController {

    var viewModel: SecurityLoginViewModel?
    
    private let loadingView = LoadingAnimation()
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
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
                    titleText: "Change Password Failed".localized,
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
        
        oldPasswordTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.oldPassword, on: viewModel)
            .store(in: &viewModel.cancellables)
        
        newPasswordTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.newPassword, on: viewModel)
            .store(in: &viewModel.cancellables)
        
        confirmPasswordTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.confirmPassword, on: viewModel)
            .store(in: &viewModel.cancellables)
        
        applyButton.tapPublisher
            .sink {
                viewModel.updateInfo()
            }
            .store(in: &viewModel.cancellables)
    }
    
}
