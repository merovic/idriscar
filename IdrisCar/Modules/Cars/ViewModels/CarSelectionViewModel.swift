//
//  CarSelectionViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 28/04/2026.
//

import Foundation
import Combine

class CarSelectionViewModel: ObservableObject {
    
    var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var brands: [FilterCommon] = []
    @Published var models: [FilterModel] = []
    @Published var versions: [FilterVersion] = []
    @Published var bodyTypes: [BodyType] = []
    
    @Published var filteredModels: [FilterModel] = []
    @Published var filteredVersions: [FilterVersion] = []
    
    @Published var selectedBrandName: String = ""
    @Published var selectedModelName: String = ""
    @Published var selectedVersionName: String = ""
    
    @Published var selectedBrandID: Int?
    @Published var selectedModelID: Int?
    @Published var selectedVersionID: Int?
    
    @Published var selectedCar: Car?
    
    @Published var isAnimating = false
    
    //---------------------
    
    let dataRepository: CarsRepository
    
    init(dataRepository: CarsRepository = RemoteCarsRepository()) {
        self.dataRepository = dataRepository
        self.getDropDowns()
    }
    
    func filterModels(byBrandID brandID: Int, in models: [FilterModel]) -> [FilterModel] {
        return models.filter { $0.brandID == brandID }
    }
    
    func filterVersions(byModelID modelID: Int, in versions: [FilterVersion]) -> [FilterVersion] {
        return versions.filter { $0.modelID == modelID }
    }
    
    func getDropDowns() {
        dataRepository.getRequestDropDowns(request: DropDownAPIRequests())
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
                    self.brands = response.data?.brands ?? []
                    self.models = response.data?.models ?? []
                    self.versions = response.data?.versions ?? []
                    self.bodyTypes = response.data?.bodyTypes ?? []
                    
                    guard let firstBrand = self.brands.first else { return }
                    self.filteredModels = self.filterModels(byBrandID: firstBrand.id, in: self.models)
                    guard let firstModel = self.filteredModels.first else { return }
                    self.filteredVersions = self.filterVersions(byModelID: firstModel.id, in: self.versions)
                    guard let firstVersion = self.filteredVersions.first else { return }
                    
                    self.selectedBrandName = firstBrand.name
                    self.selectedModelName = firstModel.name
                    self.selectedVersionName = firstVersion.name
                    
                    self.selectedBrandID = firstBrand.id
                    self.selectedModelID = firstModel.id
                    self.selectedVersionID = firstVersion.id
                    self.getCar()
                }
            )
            .store(in: &cancellables)
    }
    
    func getCar() {
        self.selectedCar = nil
        self.isAnimating = true
        dataRepository.getCars(request: CarsAPIRequest(
            brandId: self.selectedBrandID,
            modelId: self.selectedModelID,
            versionId: self.selectedVersionID))
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
                    guard let car = response.data?.data.first else {
                        self.selectedCar = nil
                        self.isAnimating = false
                        return
                    }
                    self.getCarDetails(carID: car.id)
                }
            )
            .store(in: &cancellables)
    }
    
    private func getCarDetails(carID: Int) {
        dataRepository.getCar(carID: String(carID))
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
                    self.selectedCar = response.data
                }
            )
            .store(in: &cancellables)
    }
}
