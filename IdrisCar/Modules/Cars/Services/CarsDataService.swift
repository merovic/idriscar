//
//  CarsDataService.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 29/05/2025.
//

import Foundation

class CarsDataService {
    
    static let shared = CarsDataService()
    
    private init(){}
    
    private let compareCarsKey = "compareCars"
    
    func saveCarToCompare(_ car: Car) {
        let defaults = UserDefaults.standard
        
        var currentCars = getCompareCars()
        
        // Avoid duplicates
        if !currentCars.contains(where: { $0.id == car.id }) {
            // If already 2, remove the oldest (first added)
            if currentCars.count >= 2 {
                currentCars.removeFirst()
            }
            currentCars.append(car)
        }
        
        do {
            let encodedData = try JSONEncoder().encode(currentCars)
            defaults.set(encodedData, forKey: compareCarsKey)
        } catch {
            print("Error encoding cars for comparison: \(error)")
        }
    }
    
    func getCompareCars() -> [Car] {
        if let savedData = UserDefaults.standard.data(forKey: compareCarsKey) {
            do {
                let decodedCars = try JSONDecoder().decode([Car].self, from: savedData)
                return decodedCars
            } catch {
                print("Error decoding compare cars: \(error)")
                return []
            }
        } else {
            return []
        }
    }
    
    func removeCarFromCompare(withId id: Int) {
        var currentCars = getCompareCars()
        currentCars.removeAll { $0.id == id }
        
        do {
            let encodedData = try JSONEncoder().encode(currentCars)
            UserDefaults.standard.set(encodedData, forKey: compareCarsKey)
        } catch {
            print("Error encoding cars after removal: \(error)")
        }
    }
    
    func clearCompareCars() {
        UserDefaults.standard.removeObject(forKey: compareCarsKey)
    }
}


