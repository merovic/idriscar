//
//  HomeScreenView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 02/03/2025.
//

import UIKit
import Combine
import CombineCocoa
import SDWebImage

class HomeScreenView: UIViewController {
        
    var viewModel: HomeViewModel?
    
    private let loadingView = LoadingAnimation()
    
    @IBOutlet weak var mainLogoImage: UIImageView!
    @IBOutlet weak var searchVehicleLabel: UILabel! {
        didSet {
            searchVehicleLabel.text = "Search Vehicle".localized
        }
    }
    @IBOutlet weak var userStackView: UIStackView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userAddressLabel: UILabel!
    
    @IBOutlet weak var notificationsButton: UIButton!
    
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var whatsappButton: UIButton!
    
    var filterGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    

    @IBOutlet weak var searchFilterStackView: UIStackView! {
        didSet {
            searchFilterStackView.isUserInteractionEnabled = true
            searchFilterStackView.addGestureRecognizer(filterGest)
        }
    }
        
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AttachViews()
        BindViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let viewModel = viewModel else { return }
        viewModel.getHome()
    }
    
    func AttachViews() {
        guard let viewModel = viewModel else { return }
        self.container.EmbedSwiftUIView(
            view: HomeScreenSwiftUIView(viewModel: viewModel).environmentObject(CarFavoritesManager.shared),
            parent: self)
    }
    
    func BindViews(){
        guard let viewModel = viewModel else { return }
        
        notificationsButton.tapPublisher
            .sink { _ in
                viewModel.goToNotifications()
            }
            .store(in: &viewModel.cancellables)
        
//        viewModel.$isAnimating
//            .receive(on: DispatchQueue.main)
//            .assign(to: \.isVisible, on: loadingView)
//            .store(in: &viewModel.cancellables)
        
        filterGest.tapPublisher
            .sink(receiveValue:{_ in
                self.viewModel?.goToCars()
            })
            .store(in: &viewModel.cancellables)
        
        callButton.tapPublisher
            .sink { _ in
                if let url = URL(string: "tel://+966920015755"),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
            .store(in: &viewModel.cancellables)
        
        whatsappButton.tapPublisher
            .sink { _ in
                let number = "+966920015755"
                let formattedNumber = number.replacingOccurrences(of: "+", with: "")
                
                if let url = URL(string: "https://wa.me/\(formattedNumber)"),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.$userModel.sink { [self] user in
            if let user = user {
                userImageView.image = UIImage.fromInitial(user.name, size: 20, backgroundColor: UIColor(named: "LightRed")!, textColor: UIColor(named: "AccentColor")!)
                
                userNameLabel.text = "\(user.name) \(user.lastName)"
                
                if let address = user.address {
                    userAddressLabel.text = address
                }else{
                    userAddressLabel.isHidden = true
                }
            } else {
                mainLogoImage.isHidden = false
                userStackView.isHidden = true
            }
            
        }.store(in: &viewModel.cancellables)
    }
}
