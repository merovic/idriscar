//
//  ChooseTypeView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 01/03/2025.
//

import UIKit
import Combine

class ChooseTypeView: UIViewController {
    
    var viewModel: ChooseTypeViewModel!
    
    @IBOutlet weak var individualLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    
    
    var individualGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    var companyGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    @IBOutlet weak var individualView: UIView! {
        didSet {
            individualView.isUserInteractionEnabled = true
            individualView.addGestureRecognizer(individualGest)
        }
    }
    
    @IBOutlet weak var companyView: UIView! {
        didSet {
            companyView.isUserInteractionEnabled = true
            companyView.addGestureRecognizer(companyGest)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindViews()
    }
    
    func BindViews(){
        viewModel.$registrationType
            .sink { [weak self] type in
                guard let self else { return }

                switch type {
                case .company:
                    individualView.backgroundColor = UIColor.white
                    individualView.borderWidth = 1.0
                    individualView.borderColor = UIColor.init(named: "BorderColor")
                                    
                    companyView.backgroundColor = UIColor.init(named: "LightRed")
                    companyView.borderWidth = 1.0
                    companyView.borderColor = UIColor.init(named: "AccentColor")
                    
                case .individual:
                    individualView.backgroundColor = UIColor.init(named: "LightRed")
                    individualView.borderWidth = 1.0
                    individualView.borderColor = UIColor.init(named: "AccentColor")
                                    
                    companyView.backgroundColor = UIColor.white
                    companyView.borderWidth = 1.0
                    companyView.borderColor = UIColor.init(named: "BorderColor")
                }
            }.store(in: &viewModel.cancellables)
        
        individualGest.tapPublisher
            .sink(receiveValue:{ [weak self] _ in
                self?.viewModel.registrationType = .individual
            })
            .store(in: &viewModel.cancellables)
        
        companyGest.tapPublisher
            .sink(receiveValue:{ [weak self] _ in
                self?.viewModel.registrationType = .company
            })
            .store(in: &viewModel.cancellables)
    }
    
    @IBAction func continueClicked(_ sender: Any) {
        viewModel.goToCompleteRegistration()
    }

}
