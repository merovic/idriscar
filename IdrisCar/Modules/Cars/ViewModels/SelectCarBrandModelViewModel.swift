//
//  SelectCarBrandModelViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 27/03/2025.
//

import Foundation
import Combine

class SelectCarBrandModelViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var brands: [Brand] = []
    @Published var selectedBrand: Brand? = nil
        
    //---------------------
        
    init(data: [Brand]) {
        self.brands = data
    }
}

