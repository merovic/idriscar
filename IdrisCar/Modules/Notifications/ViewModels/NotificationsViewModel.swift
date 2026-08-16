//
//  NotificationsViewModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 31/03/2025.
//

import Foundation
import Combine

class NotificationsViewModel: ObservableObject {
    
    var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var notifications: [NotificationModel] = []
        
    @Published var isAnimating = false
    
    //---------------------
    
    let dataRepository: NotificationsRepository
    weak var coordinator: HomeCoordinator?
    
    init(dataRepository: NotificationsRepository = RemoteNotificationsRepository(), coordinator: HomeCoordinator) {
        self.dataRepository = dataRepository
        self.coordinator = coordinator
        self.getNotifications()
    }
    
    func getNotifications() {
        
        self.isAnimating = true

        dataRepository.getNotifications()
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
                    self.notifications = response.data?.data ?? []
                }
            )
            .store(in: &cancellables)
    }
}



