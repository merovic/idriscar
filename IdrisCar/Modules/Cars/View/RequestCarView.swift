//
//  RequestCarView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 27/03/2025.
//

import UIKit
import SwiftUI
import Combine
import CombineCocoa
import BottomSheet
import SDWebImage

class RequestCarView: UIViewController {
    
    var viewModel: RequestCarViewModel?
    
    private let loadingView = LoadingAnimation()

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var carImage: UIImageView!
    
    var vehicleGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    @IBOutlet weak var vehicleView: UIView! {
        didSet {
            vehicleView.isUserInteractionEnabled = true
            vehicleView.addGestureRecognizer(vehicleGest)
        }
    }
    
    @IBOutlet weak var vehicleLabel: UILabel!
    
    var modelGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    @IBOutlet weak var modelView: UIView! {
        didSet {
            modelView.isUserInteractionEnabled = true
            modelView.addGestureRecognizer(modelGest)
        }
    }
    
    @IBOutlet weak var modelLabel: UILabel!
    
    var versionGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    @IBOutlet weak var versionView: UIView! {
        didSet {
            versionView.isUserInteractionEnabled = true
            versionView.addGestureRecognizer(versionGest)
        }
    }
    
    @IBOutlet weak var versionLabel: UILabel!
    
    var paymentMethodGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    
    @IBOutlet weak var paymentMethodView: UIView! {
        didSet {
            paymentMethodView.isUserInteractionEnabled = true
            paymentMethodView.addGestureRecognizer(paymentMethodGest)
        }
    }
    
    @IBOutlet weak var paymentMethodLabel: UILabel!
    
    @IBOutlet weak var salaryStackView: UIStackView!
    @IBOutlet weak var salaryView: UIView!
    @IBOutlet weak var salaryTextField: UITextField!
    
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet weak var checkBoxesContainer: UIView!
    
    @IBOutlet weak var termsCheckBox: UIButton!
    @IBOutlet weak var requestCarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AttachViews()
        BindViews()
    }
    
    func AttachViews() {
        guard let viewModel = viewModel else { return }
        self.checkBoxesContainer.EmbedSwiftUIView(view: ServicesSelectionView(viewModel: viewModel), parent: self)
    }
    
    func BindViews(){
        guard let viewModel = viewModel else { return }
        
        viewModel.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &viewModel.cancellables)
        
        backButton.tapPublisher
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.$car.sink { car in
            guard let car = car else { return }
            self.carImage.sd_setImage(with: URL(string: car.image), placeholderImage: UIImage(named: "mercedes_PNG80147"))
        }.store(in: &viewModel.cancellables)
        
        viewModel.$selectedBrandName
            .receive(on: DispatchQueue.main)
            .assign(to: \.text!, on: vehicleLabel)
            .store(in: &viewModel.cancellables)
        
        viewModel.$selectedModelName
            .receive(on: DispatchQueue.main)
            .assign(to: \.text!, on: modelLabel)
            .store(in: &viewModel.cancellables)
        
        viewModel.$selectedVersionName
            .receive(on: DispatchQueue.main)
            .assign(to: \.text!, on: versionLabel)
            .store(in: &viewModel.cancellables)
        
        viewModel.$selectedPaymentMethodName
            .receive(on: DispatchQueue.main)
            .assign(to: \.text!, on: paymentMethodLabel)
            .store(in: &viewModel.cancellables)
        
        modelGest.tapPublisher
            .sink(receiveValue:{_ in
                self.openSelectionView(title: "Model".localized, items: viewModel.models.map { $0.asSelectionItem }, key: .model)
            })
            .store(in: &viewModel.cancellables)
        
        versionGest.tapPublisher
            .sink(receiveValue:{_ in
                self.openSelectionView(title: "Version".localized, items: viewModel.filteredVersions.map { $0.asSelectionItem }, key: .version)
            })
            .store(in: &viewModel.cancellables)
        
        paymentMethodGest.tapPublisher
            .sink(receiveValue:{_ in
                self.openSelectionView(title: "Method".localized, items: viewModel.paymentMethods, key: .paymentMethod)
            })
            .store(in: &viewModel.cancellables)
        
        viewModel.$selectedPaymentMethodName
            .sink { [weak self] value in
                self?.salaryStackView.isHidden = (value == "Cash".localized)
            }
            .store(in: &viewModel.cancellables)
        
        salaryTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.salaryText, on: viewModel)
            .store(in: &viewModel.cancellables)
        
        notesTextView.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.notesText, on: viewModel)
            .store(in: &viewModel.cancellables)
        
        termsCheckBox.tapPublisher
            .sink(receiveValue:{_ in
                viewModel.isTermsAccepted.toggle()
            })
            .store(in: &viewModel.cancellables)
        
        viewModel.$isTermsAccepted.sink { value in
            self.termsCheckBox.setImage(UIImage(named: value ? "checkbox-on" : "checkbox-off"), for: .normal)
        }.store(in: &viewModel.cancellables)
        
        requestCarButton.tapPublisher
            .sink { _ in
                do {
                    try viewModel.validateCarRequest()
                    viewModel.requestCar()
                } catch {
                    ToastManager.shared.showToast(
                        iconName: "erroricon",
                        titleText: "Can't Request Car",
                        subtitleText: error.localizedDescription,
                        hapticFeedback: .notification(type: .error)
                    )
                    print(error.localizedDescription)
                }
            }
            .store(in: &viewModel.cancellables)
    }
    
    func openSelectionView(title: String, items: [SelectionItem], key: SelectionKey){
        let idrisSelectionView = IdrisSelectionView()
        idrisSelectionView.modalPresentationStyle = .overFullScreen
        idrisSelectionView.modalTransitionStyle = .crossDissolve
        idrisSelectionView.viewModel = SelectionViewModel(items: items, titleText: title)
        idrisSelectionView.delegate = self
        idrisSelectionView.selectionKey = key
        self.present(idrisSelectionView, animated: true)
    }
}

extension RequestCarView: SelectionDelegate {
    func didSelectItem(_ item: SelectionItem, for key: SelectionKey) {
        guard let viewModel = self.viewModel else { return }
        switch key {
        case .brand:
            print("")
        case .model:
            viewModel.selectedModelName = item.name
            let modelID = item.id
            let versions = viewModel.versions
            viewModel.filteredVersions = viewModel.filterVersions(byModelID: modelID, in: versions)
            if !viewModel.filteredVersions.isEmpty {
                viewModel.selectedVersionName = viewModel.filteredVersions[0].name
            }
        case .version:
            viewModel.selectedVersionName = item.name
        case .paymentMethod:
            viewModel.selectedPaymentMethodName = item.name
        case .none:
            print("")
        }
    }
}

struct ServicesSelectionView: View {
    @ObservedObject var viewModel: RequestCarViewModel
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 16) {
            ForEach(viewModel.services) { service in
                HStack {
                    Button(action: {
                        toggleSelection(for: service)
                    }) {
                        Image(viewModel.selectedServices.contains(service.id) ? "checkbox-on" : "checkbox-off")
                    }
                    
                    Text(service.name)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color("OriginalDarkGray"))
                }
            }
        }
    }
    
    private func toggleSelection(for service: FilterCommon) {
        if viewModel.selectedServices.contains(service.id) {
            viewModel.selectedServices.remove(service.id)
        } else {
            viewModel.selectedServices.insert(service.id)
        }
    }
}
