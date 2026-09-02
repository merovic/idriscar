//
//  OnboardingView.swift
//  IdrisCar
//
//  Created by Amir Morsy on 26/02/2025.
//

import UIKit

class OnboardingView: UIViewController {
    
    var viewModel: OnboardingViewModel!

    @IBOutlet weak var getStartedButton: UIButton!
    
    var onFinish: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func getStartedClicked(_ sender: Any) {
        //viewModel.goToLogin()
        onFinish?()
    }
}
