//
//  ContactUsView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 05/06/2025.
//

import UIKit

class ContactUsView: UIViewController {
    
    var viewModel: ContactUsViewModel?
    
    private let loadingView = LoadingAnimation()
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var sendButton: UIButton!
    
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
                    titleText: "Message Failed".localized,
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
        
        fullNameTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.fullName, on: viewModel)
            .store(in: &viewModel.cancellables)
        
        emailTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.email, on: viewModel)
            .store(in: &viewModel.cancellables)
        
        phoneTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.phone, on: viewModel)
            .store(in: &viewModel.cancellables)
        
        subjectTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.subject, on: viewModel)
            .store(in: &viewModel.cancellables)
        
        messageTextView.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.message, on: viewModel)
            .store(in: &viewModel.cancellables)
        
        sendButton.tapPublisher
            .sink {
                viewModel.sendMessage()
            }
            .store(in: &viewModel.cancellables)
    }
}
