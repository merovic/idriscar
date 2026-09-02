//
//  ForgetPasswordView.swift
//  IdrisCar
//
//  Created by Amir Morsy on 26/02/2025.
//

import UIKit

class ForgetPasswordView: UIViewController {
    
    private let loadingView = LoadingAnimation()
    
    var viewModel: ForgetPasswordViewModel!

    @IBOutlet weak var userNameView: UIView!{
        didSet {
            userNameView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindViews()
    }
    
    func BindViews() {
        viewModel.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &viewModel.cancellables)
        
        phoneNumberTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.phoneNumber, on: viewModel)
            .store(in: &viewModel.cancellables)
        
        viewModel.$errorMessage
            .filter { !$0.isEmpty }
            .sink { errorMessage in
                ToastManager.shared.showToast(
                    iconName: "erroricon",
                    titleText: "OTP Failed".localized,
                    subtitleText: errorMessage,
                    hapticFeedback: .notification(type: .error)
                )
            }
            .store(in: &viewModel.cancellables)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func resetPasswordClicked(_ sender: Any) {
        viewModel.sendOTP()
    }
}
