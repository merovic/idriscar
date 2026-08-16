//
//  FilterViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 31/03/2025.
//

import Foundation
import Combine

class FilterViewModel: ObservableObject {
    
    var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var backPressed: Bool = false
    
    @Published var sliderPosition: ClosedRange<Float> = 20000...30000
        
    @Published var carTypes: [CarType] = [
        CarType(id: 1, name: "Sedan"),
        CarType(id: 2, name: "SUVs (Sport Utility Vehicles)")
    ]
    
    @Published var selectedBodyTypeID: Int?
    
    @Published var brands: [Brand] = []
    @Published var allModels: [FilterModel] = []
    @Published var allVersions: [FilterVersion] = []
    @Published var filteredVersions: [FilterVersion] = []
    
    @Published var selectedBrandID: Int? {
        didSet {
            getRestOfData(brandID: selectedBrandID)
        }
    }
    
    @Published var selectedModelID: Int? {
        didSet {
            filteredVersions = filterVersions()
        }
    }
    
    @Published var selectedVersionID: Int?
        
    @Published var isAnimating = false
    
    var onFilterCars: ((CarsAPIRequest) -> Void)?
    
    //---------------------
    
    let dataRepository: CarsRepository
    
    init(dataRepository: CarsRepository = RemoteCarsRepository()) {
        self.dataRepository = dataRepository
        self.getBrands()
    }
    
    func applyFilter(){
        onFilterCars?(CarsAPIRequest(brandId: selectedBrandID, modelId: selectedModelID, bodyTypeId: selectedBodyTypeID, priceFrom: Int(sliderPosition.upperBound), priceTo: Int(sliderPosition.upperBound)))
    }
    
    func resetAll(){
        selectedBrandID = nil
        selectedModelID = nil
        selectedVersionID = nil
        selectedBodyTypeID = nil
    }
    
    func filterModels(byBrandID brandID: Int, in models: [FilterModel]) -> [FilterModel] {
        return models.filter { $0.brandID == brandID }
    }
    
    func filterVersions() -> [FilterVersion] {
        return allVersions.filter { $0.modelID == selectedModelID }
    }
    
    func getBrands() {
        guard brands.isEmpty else {
            return
        }
        self.isAnimating = true
        dataRepository.getBrands()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        print("Publisher stopped observing")
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.isAnimating = false
                    }
                },
                receiveValue: { response in
                    self.isAnimating = false
                    let fetchedBrands = response.data?.data ?? []
                    self.brands = fetchedBrands
                }
            )
            .store(in: &cancellables)
    }
    
    func getRestOfData(brandID: Int?) {
        guard brandID != nil else {
            return
        }
        dataRepository.getRequestDropDowns(request: DropDownAPIRequests(brandId: brandID))
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        print("Publisher stopped observing")
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.isAnimating = false
                    }
                },
                receiveValue: { response in
                    self.isAnimating = false
                    let fetchedModels = response.data?.models ?? []
                    let fetchedVersions = response.data?.versions ?? []
                    
                    self.allModels = fetchedModels
                    self.allVersions = fetchedVersions
                }
            )
            .store(in: &cancellables)
    }
}
