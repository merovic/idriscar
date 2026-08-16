//
//  CarsViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 25/03/2025.
//

import Foundation
import Combine

class CarsViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var searchText = ""
    
    @Published var brands: [Brand] = []
    
    @Published var cars: [Car] = []
    
    @Published var selectedBrandIndex: Int? = nil
    
    @Published var selectedCarID: Int? = nil
    
    @Published var isBackButtonVisible: Bool?
    
    @Published var isAnimating = false
    
    //---------------------
        
    let dataRepository: CarsRepository
    weak var coordinator: CarsCoordinator?
    
    init(dataRepository: CarsRepository = RemoteCarsRepository(), coordinator: CarsCoordinator?, brandID: String? = nil, isBackButtonVisible: Bool? = false) {
        self.coordinator = coordinator
        self.dataRepository = dataRepository
        guard let brandID = brandID else { return }
        self.selectBrand(index: Int(brandID))
        self.isBackButtonVisible = isBackButtonVisible
    }
    
    func goToCarDetails(){
        guard let selectedCarID = self.selectedCarID else { return }
        coordinator?.goToCarDetails(carID: selectedCarID, offerID: nil)
    }
    
    func goToFilter(){
        coordinator?.goToFilter { [weak self] carsRequest in
            self?.getFilteredCars(request: carsRequest)
        }
    }
    
    func selectBrand(index: Int?) {
        selectedBrandIndex = index
        getFilteredCars(request: CarsAPIRequest(brandId: index))
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
                    self.brands = response.data?.data ?? []
                }
            )
            .store(in: &cancellables)
    }
    
    func getCars() {
        guard cars.isEmpty else {
            return
        }
        
        guard selectedBrandIndex == nil else {
            return
        }
        
        self.isAnimating = true

        dataRepository.getCars(request: CarsAPIRequest())
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
                    self.cars = response.data?.data ?? []
                }
            )
            .store(in: &cancellables)
    }
    
    func getFilteredCars(request: CarsAPIRequest) {
        self.isAnimating = true
        self.selectedBrandIndex = request.brandId
        dataRepository.getCars(request: request)
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
                    self.cars = response.data?.data ?? []
                    let favoriteIDs = self.cars.filter { $0.isFavorite ?? false }.map { $0.id }
                    CarFavoritesManager.shared.setFavorites(from: favoriteIDs)
                }
            )
            .store(in: &cancellables)
    }
}
