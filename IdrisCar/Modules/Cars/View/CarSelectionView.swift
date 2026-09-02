//
//  CarSelectionView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 28/04/2026.
//

import UIKit

protocol CarSelectionViewDelegate {
    func didSelectCar(car: Car)
}

class CarSelectionView: UIViewController {
    
    var viewModel: CarSelectionViewModel?
    
    private let loadingView = LoadingAnimation()
    
    var delegate: CarSelectionViewDelegate!

    @IBOutlet weak var backButton: UIButton!
    
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
    
    @IBOutlet weak var addToComparisonButton: UIButton!
    
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
        
        backButton.tapPublisher
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &viewModel.cancellables)
        
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
        
        viewModel.$selectedCar
            .receive(on: DispatchQueue.main)
            .sink { [weak addToComparisonButton] car in
                car == nil ? addToComparisonButton?.disable() : addToComparisonButton?.enable()
            }
            .store(in: &viewModel.cancellables)
        
        vehicleGest.tapPublisher
            .sink(receiveValue:{_ in
                self.openSelectionView(title: "Brand".localized, items: viewModel.brands.map { $0.asSelectionItem }, key: .brand)
            })
            .store(in: &viewModel.cancellables)
        
        modelGest.tapPublisher
            .sink(receiveValue:{_ in
                self.openSelectionView(title: "Model".localized, items: viewModel.filteredModels.map { $0.asSelectionItem }, key: .model)
            })
            .store(in: &viewModel.cancellables)
        
        versionGest.tapPublisher
            .sink(receiveValue:{_ in
                self.openSelectionView(title: "Version".localized, items: viewModel.filteredVersions.map { $0.asSelectionItem }, key: .version)
            })
            .store(in: &viewModel.cancellables)
        
        addToComparisonButton.tapPublisher
            .sink { _ in
                guard let car = viewModel.selectedCar else { return }
                self.delegate.didSelectCar(car: car)
                self.navigationController?.popViewController(animated: true)
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

extension CarSelectionView: SelectionDelegate {
    func didSelectItem(_ item: SelectionItem, for key: SelectionKey) {
        guard let viewModel = self.viewModel else { return }
        switch key {
        case .brand:
            viewModel.selectedBrandName = item.name
            viewModel.selectedBrandID = item.id
            let brandID = item.id
            let models = viewModel.models
            viewModel.filteredModels = viewModel.filterModels(byBrandID: brandID, in: models)
            if !viewModel.filteredModels.isEmpty {
                viewModel.selectedModelName = viewModel.filteredModels[0].name
                viewModel.selectedModelID = viewModel.filteredModels[0].id
                let versions = viewModel.versions
                viewModel.filteredVersions = viewModel.filterVersions(byModelID: viewModel.filteredModels[0].id, in: versions)
                if !viewModel.filteredVersions.isEmpty {
                    viewModel.selectedVersionName = viewModel.filteredVersions[0].name
                    viewModel.selectedVersionID = viewModel.filteredVersions[0].id
                }
            }
            viewModel.getCar()
        case .model:
            viewModel.selectedModelName = item.name
            viewModel.selectedModelID = item.id
            let modelID = item.id
            let versions = viewModel.versions
            viewModel.filteredVersions = viewModel.filterVersions(byModelID: modelID, in: versions)
            if !viewModel.filteredVersions.isEmpty {
                viewModel.selectedVersionName = viewModel.filteredVersions[0].name
                viewModel.selectedVersionID = viewModel.filteredVersions[0].id
            }
            viewModel.getCar()
        case .version:
            viewModel.selectedVersionName = item.name
            viewModel.selectedVersionID = item.id
            viewModel.getCar()
        case .none:
            print("")
        case .paymentMethod:
            print("")
        }
    }
}
