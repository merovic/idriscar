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
                    
                    self.filteredModels = self.filterModels(byBrandID: self.brands[0].id, in: self.models)
                    self.filteredVersions = self.filterVersions(byModelID: self.models[0].id, in: self.versions)
                    
                    self.selectedBrandName = response.data?.brands[0].name ?? ""
                    self.selectedModelName = response.data?.models[0].name ?? ""
                    self.selectedVersionName = response.data?.versions[0].name ?? ""
                    
                    self.selectedBrandID = response.data?.brands[0].id
                    self.selectedModelID = response.data?.models[0].id
                    self.selectedVersionID = response.data?.versions[0].id
                }
            )
            .store(in: &cancellables)
    }
    
    func getCar() {
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
                    self.isAnimating = false
                    guard let data = response.data?.data else { return }
                    if !data.isEmpty {
                        self.selectedCar = data[0]
                    }
                }
            )
            .store(in: &cancellables)
    }
}
