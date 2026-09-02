//
//  CompleteRegistrationView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 01/03/2025.
//

import UIKit
import BottomSheet
import Combine
import CombineCocoa

class CompleteRegistrationView: UIViewController {
    
    var viewModel: CompleteRegistrationViewModel!
    private let loadingView = LoadingAnimation()
    
    // MARK: - Company Name
    @IBOutlet weak var companyNameStackView: UIStackView!
    @IBOutlet weak var companyNameTextField: UITextField!
    
    // MARK: - Company Email
    @IBOutlet weak var companyEmailStackView: UIStackView!
    @IBOutlet weak var companyEmailTextField: UITextField!
    
    // MARK: - First Name
    @IBOutlet weak var firstNameStackView: UIStackView!
    @IBOutlet weak var firstNameTextField: UITextField!
    
    // MARK: - Last Name
    @IBOutlet weak var lastNameStackView: UIStackView!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    // MARK: - Phone Number
    @IBOutlet weak var phoneNumberStackView: UIStackView!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    // MARK: - Email Address
    @IBOutlet weak var emailAddressStackView: UIStackView!
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    // MARK: - City
    @IBOutlet weak var cityStackView: UIStackView!
    @IBOutlet weak var cityTextField: UITextField!
    
    // MARK: - Password
    @IBOutlet weak var passwordStackView: UIStackView!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Confirm Password
    @IBOutlet weak var confirmPasswordStackView: UIStackView!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    // MARK: - Social Networks Checkbox
    @IBOutlet weak var selectAllCheckBoxButton: UIButton!
    @IBOutlet weak var smsCheckBoxButton: UIButton!
    @IBOutlet weak var emailCheckBoxButton: UIButton!
    @IBOutlet weak var phoneCallCheckBoxButton: UIButton!
    @IBOutlet weak var socialMediaCheckBoxButton: UIButton!
    @IBOutlet weak var whatsappCheckBoxButton: UIButton!
    
    // MARK: - Terms & Conditions Checkbox
    @IBOutlet weak var termsCheckBoxButton: UIButton!
    
    // MARK: - Confirm Button
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFormVisibility()
        BindViews()
    }
    
    func updateFormVisibility() {
        let isCompany = viewModel.isCompany
        
        // Company-related views
        [companyNameStackView, companyEmailStackView].forEach { $0?.isHidden = !isCompany }
        
        // Individual-related views
        [firstNameStackView, lastNameStackView, emailAddressStackView].forEach { $0?.isHidden = isCompany }
    }
    
    func BindViews() {
        // Loading indicator binding
        viewModel.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &viewModel.cancellables)
        
        // Bind errorMessage to show toast
        viewModel.$errorMessage
            .compactMap { $0 }
            .sink { errorMessage in
                ToastManager.shared.showToast(
                    iconName: "erroricon",
                    titleText: "Registration Failed".localized,
                    subtitleText: errorMessage,
                    hapticFeedback: .notification(type: .error)
                )
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.$phoneNumber
            .compactMap { $0 }
            .sink { phoneNumber in
                self.phoneNumberTextField.text = phoneNumber
            }
            .store(in: &viewModel.cancellables)
        
        // Company Name
        companyNameTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.companyName, on: viewModel)
            .store(in: &viewModel.cancellables)
        
        // Company Email
        companyEmailTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.companyEmail, on: viewModel)
            .store(in: &viewModel.cancellables)
        
        // First Name
        firstNameTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.firstName, on: viewModel)
            .store(in: &viewModel.cancellables)
        
        // Last Name
        lastNameTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.lastName, on: viewModel)
            .store(in: &viewModel.cancellables)
        
        // Phone Number
        phoneNumberTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.phoneNumber, on: viewModel)
            .store(in: &viewModel.cancellables)
        
        // Email Address
        emailAddressTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.emailAddress, on: viewModel)
            .store(in: &viewModel.cancellables)
        
        // City
        cityTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.city, on: viewModel)
            .store(in: &viewModel.cancellables)
        
        // Password
        passwordTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.password, on: viewModel)
            .store(in: &viewModel.cancellables)
        
        // Confirm Password
        confirmPasswordTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.confirmPassword, on: viewModel)
            .store(in: &viewModel.cancellables)
        
        // Terms Checkbox Action
        viewModel.$isTermsAccepted.sink { value in
            self.termsCheckBoxButton.setImage(UIImage(named: value ? "checkbox-on" : "checkbox-off"), for: .normal)
        }.store(in: &viewModel.cancellables)
        
        // Confirm button click handler
//        confirmButton.tapPublisher
//            .sink { [weak self] in
//                self?.continueClicked(self as Any)
//            }
//            .store(in: &viewModel.cancellables)
    }
    
    @IBAction func checkBoxTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            sender.setImage(UIImage(named: "checkbox-on"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "checkbox-off"), for: .normal)
        }
        
        if sender == selectAllCheckBoxButton {
            let newState = sender.isSelected
            
            [
                smsCheckBoxButton,
                emailCheckBoxButton,
                phoneCallCheckBoxButton,
                socialMediaCheckBoxButton,
                whatsappCheckBoxButton
            ].forEach {
                $0?.isSelected = newState
                $0?.setImage(UIImage(named: newState ? "checkbox-on" : "checkbox-off"), for: .normal)
            }
            
            if newState {
                viewModel.contactOptions = ["1", "2", "3", "4", "5"]
            } else {
                viewModel.contactOptions.removeAll()
            }
        } else {
            let number = String(sender.tag)
            if sender.isSelected {
                if !viewModel.contactOptions.contains(number) {
                    viewModel.contactOptions.append(number)
                }
            } else {
                if let index = viewModel.contactOptions.firstIndex(of: number) {
                    viewModel.contactOptions.remove(at: index)
                }
            }
            
            let allSelected = [
                smsCheckBoxButton,
                emailCheckBoxButton,
                phoneCallCheckBoxButton,
                socialMediaCheckBoxButton,
                whatsappCheckBoxButton
            ].allSatisfy { $0?.isSelected == true }
            
            selectAllCheckBoxButton.isSelected = allSelected
            selectAllCheckBoxButton.setImage(UIImage(named: allSelected ? "checkbox_checked" : "checkbox_unchecked"), for: .normal)
        }
        
        print("Selected preferences: \(viewModel.contactOptions)")
    }
    
    @IBAction func termsCheckClicked(_ sender: Any) {
        viewModel.isTermsAccepted.toggle()
    }
    
    
    @IBAction func continueClicked(_ sender: Any) {
        viewModel.signup()
    }
}
