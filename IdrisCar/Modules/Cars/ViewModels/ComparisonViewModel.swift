//
//  ComparisonViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 29/05/2025.
//

import Foundation
import Combine

class ComparisonViewModel: ObservableObject {
    
    var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var comparison: CarComparisonModel?
    
    @Published var carsToCompare: [Car] = []
    
    @Published var addCarPressed: Bool = false
    
    var onRequestClicked: ((Car) -> Void)?
    
    init() {
        createComparison()
    }
    
    func createComparison() {
        carsToCompare = CarsDataService.shared.getCompareCars()
        if let car1 = carsToCompare[safe: 0] {
            let car2 = carsToCompare[safe: 1]
            self.comparison = createComparisonModel(car1: car1, car2: car2)
        } else {
            print("At least one car (car1) is required for comparison.")
        }
    }
    
    func requestCar(car: Car){
        onRequestClicked?(car)
    }
    
    func deleteCar(carID: Int){
        CarsDataService.shared.removeCarFromCompare(withId: carID)
        carsToCompare = CarsDataService.shared.getCompareCars()
        if let car1 = carsToCompare[safe: 0] {
            let car2 = carsToCompare[safe: 1]
            self.comparison = createComparisonModel(car1: car1, car2: car2)
        } else {
            print("At least one car (car1) is required for comparison.")
        }
    }
    
    func createComparisonModel(car1: Car, car2: Car? = nil) -> CarComparisonModel {
        var combinedGroups: [FeatureComparison] = []
        
        // Collect all unique group names from both cars (if car2 exists)
        let allGroupNames = Set((car1.featuresGroups ?? []).map { $0.groupName } +
                                (car2?.featuresGroups ?? []).map { $0.groupName })
        
        for groupName in allGroupNames {
            // Features in this group for both cars
            let car1Features = car1.featuresGroups?.first(where: { $0.groupName == groupName })?.features ?? []
            let car2Features = car2?.featuresGroups?.first(where: { $0.groupName == groupName })?.features ?? []
            
            // All unique feature names in this group
            let allFeatureNames = Set(car1Features.map { $0.name } + car2Features.map { $0.name })
            
            var combinedFeatures: [FeatureItemComparison] = []
            
            for featureName in allFeatureNames {
                let car1Value = car1Features.first(where: { $0.name == featureName })?.value ?? ""
                let car2Value = car2Features.first(where: { $0.name == featureName })?.value ?? ""
                
                let item = FeatureItemComparison(
                    name: featureName,
                    car1Value: car1Value,
                    car2Value: car2 != nil ? car2Value : ""
                )
                combinedFeatures.append(item)
            }
            
            let combinedGroup = FeatureComparison(
                groupName: groupName,
                features: combinedFeatures.sorted { $0.name < $1.name }
            )
            combinedGroups.append(combinedGroup)
        }
        
        return CarComparisonModel(
            car1: car1,
            car2: car2,
            featureGroups: combinedGroups.sorted { $0.groupName < $1.groupName }
        )
    }
    
}
