//
//  CarDetailsViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 26/03/2025.
//

import Foundation
import Combine

class CarDetailsViewModel: ObservableObject {
    
    var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var car: Car?
    
    @Published var carImage: String = ""
    
    @Published var selectedType = 0
        
    @Published var selectedColor: ColorItem?
    
    @Published var albumClicked = false
    
    @Published var backPressed = false
    
    @Published var comparisonPressed = false
        
    @Published var isAnimating = false
    
    var onRequestCar: ((Car) -> Void)?
    
    //---------------------
    
    let dataRepository: CarsRepository
    
    init(dataRepository: CarsRepository = RemoteCarsRepository(), carID: Int) {
        self.dataRepository = dataRepository
        self.getCar(carID: carID)
    }
    
    func goToRequestCarFlow(){
        guard let car = self.car else { return }
        onRequestCar?(car)
    }
    
    func goToRequestCarFlowSpecific(car: Car){
        onRequestCar?(car)
    }
    
    func getCar(carID: Int){
        self.isAnimating = true

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
                    self.car = response.data
                    guard let car = self.car else { return }
                    self.carImage = car.image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                }
            )
            .store(in: &cancellables)
    }
}

