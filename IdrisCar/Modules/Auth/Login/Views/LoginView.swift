//
//  LoginView.swift
//  IdrisCar
//
//  Created by Amir Morsy on 26/02/2025.
//

import UIKit
import Combine
import CombineCocoa

class LoginView: UIViewController {
        
    var viewModel: LoginViewModel!
        
    private let loadingView = LoadingAnimation()
        
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var phoneView: UIView! {
        didSet {
            phoneView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var phoneTextField: UITextField!
        
    @IBOutlet weak var passwordView: UIView! {
        didSet {
            passwordView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField!
                   
    @IBOutlet weak var signInButton: UIButton! {
        didSet {
            signInButton.enable()
        }
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindView()
    }
    
    func BindView(){
        
        viewModel.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &viewModel.cancellables)
        
        viewModel.$errorMessage
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
        
        phoneTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.phoneText, on: viewModel)
            .store(in: &viewModel.cancellables)
        
        //self.subscripeSaudiArabia()
        
        passwordTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.passwordText, on: viewModel)
            .store(in: &viewModel.cancellables)
        
        
        viewModel.$passwordEyeOn
            .receive(on: DispatchQueue.main)
            .assign(to: \.isSecureTextEntry, on: passwordTextField)
            .store(in: &viewModel.cancellables)
        
        passwordGest.tapPublisher
            .sink(receiveValue:{_ in
                self.passwordEye.image = UIImage(systemName: self.viewModel.passwordEyeOn ? "eye.slash.fill" : "eye.fill")
                self.viewModel.switchPasswordEye()
            })
            .store(in: &viewModel.cancellables)
        
        keyboardHelper = KeyboardHelper {animation, keyboardFrame, duration in
            switch animation {
            case .keyboardWillShow:
                self.headerView.isHidden = true
                self.topConstraint.constant = 50
            case .keyboardWillHide:
                self.headerView.isHidden = false
                self.topConstraint.constant = 0
            }
        }
        
    }
    
//    func subscripeSaudiArabia(){
//        viewModel.saudiArabiaValidationSubscription = phoneTextField.textPublisher
//            .removeDuplicates()
//            .debounce(for: 0.2, scheduler: RunLoop.main)
//            .validateText(validationType: .phone(country: .saudiArabia))
//            .assign(to: \.phoneValidationState, on: viewModel)
//    }
    
    @IBAction func skipClicked(_ sender: Any) {
        viewModel.goToHomeScreen()
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        viewModel.goToSignUp()
    }
    
    @IBAction func forgetPasswordClicked(_ sender: Any) {
        viewModel.goToForgetPassword()
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        self.viewModel.login()
    }
}
