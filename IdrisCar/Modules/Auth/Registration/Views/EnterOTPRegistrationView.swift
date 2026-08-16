//
//  EnterOTPRegistrationView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 01/03/2025.
//

import UIKit
import SwiftyCodeView

class EnterOTPRegistrationView: UIViewController {
    
    private let loadingView = LoadingAnimation()
    
    var viewModel: EnterOTPViewModel!
    
    @IBOutlet weak var otpView: CustomCodeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otpView.delegate = self
        BindViews()
    }
    
    func BindViews(){
        viewModel.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &viewModel.cancellables)
    }

    @IBAction func continueClicked(_ sender: Any) {
        self.viewModel.otpCheck()
    }
    
    @IBAction func resendClicked(_ sender: Any) {
        viewModel.isForgetPassword ? self.viewModel.sendOTPForget() : self.viewModel.sendOTP()
    }
}

extension EnterOTPRegistrationView: SwiftyCodeViewDelegate {
    func codeView(sender: SwiftyCodeView, didFinishInput code: String) -> Bool {
        self.viewModel.codeText = code
        return true
    }
}
