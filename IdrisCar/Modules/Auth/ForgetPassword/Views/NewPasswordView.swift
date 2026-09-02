//
//  NewPasswordView.swift
//  IdrisCar
//
//  Created by Amir Morsy on 26/02/2025.
//

import UIKit
import BottomSheet

class NewPasswordView: UIViewController {
    
    private let loadingView = LoadingAnimation()
    
    var viewModel: NewPasswordViewModel!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var passwordView: UIView!{
        didSet {
            passwordView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var confirmView: UIView!{
        didSet {
            confirmView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    private var keyboardHelper: KeyboardHelper?
    
    var passwordGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    @IBOutlet weak var passwordEye: UIImageView! {
        didSet {
            passwordEye.isUserInteractionEnabled = true
            passwordEye.addGestureRecognizer(passwordGest)
        }
    }
    
    var confirmPasswordGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    @IBOutlet weak var confirmPasswordEye: UIImageView! {
        didSet {
            confirmPasswordEye.isUserInteractionEnabled = true
            confirmPasswordEye.addGestureRecognizer(confirmPasswordGest)
        }
    }
    
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindView()
    }
    
    func BindView(){
        
        viewModel.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &viewModel.cancellables)
        
        passwordTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.passwordText, on: viewModel)
        .store(in: &viewModel.cancellables)
        
        confirmPasswordTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.confirmPasswordText, on: viewModel)
        .store(in: &viewModel.cancellables)
        
        viewModel.$passwordEyeOn
            .receive(on: DispatchQueue.main)
            .assign(to: \.isSecureTextEntry, on: passwordTextField)
            .store(in: &viewModel.cancellables)
        
        viewModel.$confirmPasswordEyeOn
            .receive(on: DispatchQueue.main)
            .assign(to: \.isSecureTextEntry, on: confirmPasswordTextField)
            .store(in: &viewModel.cancellables)
        
        passwordGest.tapPublisher
            .sink(receiveValue:{_ in
                self.passwordEye.image = UIImage(systemName: self.viewModel.passwordEyeOn ? "eye.slash.fill" : "eye.fill")
                self.viewModel.switchPasswordEye()
            })
            .store(in: &viewModel.cancellables)
        
        confirmPasswordGest.tapPublisher
            .sink(receiveValue:{_ in
                self.confirmPasswordEye.image = UIImage(systemName: self.viewModel.confirmPasswordEyeOn ? "eye.slash.fill" : "eye.fill")
                self.viewModel.switchConfirmPasswordEye()
            })
            .store(in: &viewModel.cancellables)
        
        viewModel.$errorMessage
            .compactMap { $0?.isEmpty == false ? $0 : nil }
            .sink { errorMessage in
                ToastManager.shared.showToast(
                    iconName: "erroricon",
                    titleText: "Password Reset Failed".localized,
                    subtitleText: errorMessage,
                    hapticFeedback: .notification(type: .error)
                )
            }
            .store(in: &viewModel.cancellables)
        
        keyboardHelper = KeyboardHelper {animation, keyboardFrame, duration in
            switch animation {
            case .keyboardWillShow:
                self.headerView.isHidden = true
                self.topConstraint.constant = 12
            case .keyboardWillHide:
                self.headerView.isHidden = false
                self.topConstraint.constant = 0
            }
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmClicked(_ sender: Any) {
        viewModel.showPasswordChanged()
    }
}
