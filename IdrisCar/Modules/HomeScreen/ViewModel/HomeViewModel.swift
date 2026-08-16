//
//  HomeViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 03/03/2025.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var userModel: User?
    
    @Published var cars: [Car] = []
    @Published var slideshow: [HomeModel] = []
    @Published var brands: [Brand] = []
    @Published var agencyInformation: [HomeModel] = []
    @Published var services: [Service] = []
    @Published var banks: [HomeModel] = []
    @Published var finances: [HomeModel] = []
    @Published var offers: [Offer] = []
    @Published var clients: [HomeModel] = []
    @Published var testimonials: [HomeModel] = []
        
    @Published var selectedCar: Car?
    @Published var selectedOffer: Offer?
    @Published var selectedService: Service?
    
    var showOfferDetails: ((String) -> Void)?
    var showServiceDetails: ((String) -> Void)?
    var showCarsWithBrand: ((String) -> Void)?
    
    @Published var isAnimating = false
    
    //---------------------
        
    let dataRepository: HomeRepository
    weak var coordinator: HomeCoordinator?
    
    init(dataRepository: HomeRepository = RemoteHomeRepository(), coordinator: HomeCoordinator?) {
        self.coordinator = coordinator
        self.dataRepository = dataRepository
        self.getHome()
        self.getUserInfo()
    }
    
    func getUserInfo() {
        self.userModel = LoginDataService.shared.getUserData()?.user
    }
    
    func goToNotifications(){
        coordinator?.goToNotifications()
    }
    
    func goToFilter(){
        coordinator?.goToFilter()
    }
    
    func goToBrands(){
        coordinator?.goToBrands()
    }
    
    func goToCarDetails(){
        guard let carID = selectedCar?.id else { return }
        coordinator?.goToCarDetails(carID: carID, offerID: nil)
    }
    
    func goToOffers(){
        coordinator?.goToOffersTab()
    }
    
    func goToOfferDetails() {
        guard let offerID = selectedOffer?.id else { return }
        showOfferDetails?(String(offerID))
    }
    
    func goToServices(){
        coordinator?.goToServicesTab()
    }
    
    func goToCars(){
        coordinator?.goToCarsTab()
    }
    
    func goToCarsWithBrand(brandID: String){
        showCarsWithBrand?(String(brandID))
    }
    
    func goToServiceDetails() {
        guard let serviceID = selectedService?.id else { return }
        showServiceDetails?(String(serviceID))
    }
    
    func getHome() {
        guard cars.isEmpty else {
            return
        }
        self.isAnimating = true
        dataRepository.getHome()
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
                    self.cars = response.data?.cars ?? []
                    self.slideshow = response.data?.slideshow ?? []
                    self.brands = response.data?.brands ?? []
                    self.agencyInformation = response.data?.agencyInformation ?? []
                    self.services = response.data?.services ?? []
                    self.banks = response.data?.banks ?? []
                    self.finances = response.data?.finances ?? []
                    self.offers = response.data?.offers ?? []
                    self.clients = response.data?.clients ?? []
                    self.testimonials = response.data?.testimonials ?? []
                    
                    let favoriteIDs = self.cars.filter { $0.isFavorite ?? false }.map { $0.id }
                    CarFavoritesManager.shared.setFavorites(from: favoriteIDs)
                }
            )
            .store(in: &cancellables)
    }
}
