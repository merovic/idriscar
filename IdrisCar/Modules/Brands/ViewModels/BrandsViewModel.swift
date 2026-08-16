//
//  BrandsViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 25/03/2025.
//

import Foundation
import Combine

class BrandsViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var brands: [Brand] = []
    
    @Published var selectedBrandID: Int?
    
    @Published var isAnimating = false
    
    var showCars: ((String) -> Void)?
    
    //---------------------
    
    let dataRepository: CarsRepository
    weak var coordinator: HomeCoordinator?
    
    init(dataRepository: CarsRepository = RemoteCarsRepository(), coordinator: HomeCoordinator?) {
        self.dataRepository = dataRepository
        self.coordinator = coordinator
        self.getBrands()
    }
    
    func goToCars(){
        guard let brandID = selectedBrandID else { return }
        showCars?(String(brandID))
    }
    
    func getBrands() {
        
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
}
