//
//  RequestCarViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 31/03/2025.
//

import Foundation
import Combine

class RequestCarViewModel: ObservableObject {
    
    var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var models: [FilterModel] = []
    @Published var versions: [FilterVersion] = []
    @Published var bodyTypes: [BodyType] = []
    @Published var services: [FilterCommon] = []
    @Published var paymentMethods: [SelectionItem] = [
        SelectionItem(id: 1, name: "Cash".localized),
        SelectionItem(id: 2, name: "Installment".localized)
    ]
    
    @Published var filteredVersions: [FilterVersion] = []
    
    @Published var selectedBrandName: String = ""
    @Published var selectedModelName: String = ""
    @Published var selectedVersionName: String = ""
    @Published var selectedPaymentMethodName: String = "Cash".localized
    @Published var salaryText: String = ""
    @Published var notesText: String = ""
    
    @Published var selectedServices: Set<Int> = []
    
    @Published var isTermsAccepted = false
    @Published var isAnimating = false
    
    //---------------------
    
    @Published var car: Car?
    var offerID: Int?
    
    let dataRepository: CarsRepository
    weak var coordinator: RequestCarCoordinator?
    
    init(dataRepository: CarsRepository = RemoteCarsRepository(), coordinator: RequestCarCoordinator?, car: Car?, offerID: Int? = nil) {
        self.dataRepository = dataRepository
        self.coordinator = coordinator
        self.car = car
        self.getDropDowns()
    }
    
    func showSuccessView(){
        coordinator?.showWelcomeToIdris()
    }
    
    func validateCarRequest() throws {
        guard car != nil else { throw CarRequestValidationError.noCarSelected }

        if selectedPaymentMethodName != "Cash".localized && salaryText.trimmingCharacters(in: .whitespaces).isEmpty {
            throw CarRequestValidationError.missingSalary
        }
        
        if !isTermsAccepted {
            throw CarRequestValidationError.termsNotAccepted
        }
    }
    
    func filterModels(byBrandID brandID: Int, in models: [FilterModel]) -> [FilterModel] {
        return models.filter { $0.brandID == brandID }
    }
    
    func filterVersions(byModelID modelID: Int, in versions: [FilterVersion]) -> [FilterVersion] {
        return versions.filter { $0.modelID == modelID }
    }
    
    func selectedServiceIDs(from selectedIDs: Set<Int>, in services: [FilterCommon]) -> [Int] {
        services.filter { selectedIDs.contains($0.id) }
            .map { $0.id }
    }
    
    private var selectedPaymentMethodAPIName: String {
        if selectedPaymentMethodName == "Cash".localized {
            return "cash"
        }
        
        if selectedPaymentMethodName == "Installment".localized {
            return "installment"
        }
        
        return selectedPaymentMethodName.lowercased()
    }
    
    func getDropDowns() {
        guard let car = self.car else { return }
        dataRepository.getRequestDropDowns(request: DropDownAPIRequests(brandId: car.brandID))
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
                    self.models = response.data?.models ?? []
                    self.versions = response.data?.versions ?? []
                    self.bodyTypes = response.data?.bodyTypes ?? []
                    self.services = response.data?.services ?? []
                    
                    self.filteredVersions = self.filterVersions(byModelID: self.models[0].id, in: self.versions)
                    
                    self.selectedBrandName = response.data?.brands[0].name ?? ""
                    self.selectedModelName = response.data?.models[0].name ?? ""
                    self.selectedVersionName = response.data?.versions[0].name ?? ""
                }
            )
            .store(in: &cancellables)
    }
    
    func requestCar() {
        guard let car = car else { return }

        let selectedServiceNames = selectedServiceIDs(from: selectedServices, in: services)
        let offerIDString = offerID.map { String($0) }
        let notes = notesText.isEmpty ? nil : notesText
        let salary = salaryText.isEmpty ? nil : salaryText

        let request = CarRequestAPIRequest(
            carID: String(car.id),
            offerID: offerIDString,
            services: selectedServiceNames,
            paymentType: selectedPaymentMethodAPIName,
            salary: salary,
            notes: notes
        )

        self.isAnimating = true
        
        dataRepository.requestCar(request: request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                    self.isAnimating = false
                } else {
                    print("Publisher stopped observing")
                }
            } receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.isAnimating = false
                self.showSuccessView()
            }
            .store(in: &cancellables)
    }
}


enum CarRequestValidationError: Error, LocalizedError {
    case noCarSelected
    case missingSalary
    case termsNotAccepted

    var errorDescription: String? {
        switch self {
        case .noCarSelected: return "Please select a car.".localized
        case .missingSalary: return "Salary is required for installment".localized
        case .termsNotAccepted: return "You must accept the terms and conditions.".localized
        }
    }
}
