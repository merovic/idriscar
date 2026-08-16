//
//  CarGalleryViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 22/06/2025.
//

import Foundation
import Combine

class CarGalleryViewModel: ObservableObject {
    
    var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var albums: [Album] = []
    
    @Published var selectedAlbum: Album?
    
    @Published var errorMessage =  ""
    @Published var isAnimating = false
    
    @Published var selectedImage: ImageItem? = nil
        
    let dataRepository: CarsRepository
    weak var coordinator: CarsCoordinator?
    
    init(dataRepository: CarsRepository = RemoteCarsRepository(), albums: [Album]) {
        self.dataRepository = dataRepository
        self.albums = albums
    }
}

