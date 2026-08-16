//
//  NotificationsService.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 19/06/2026.
//

import Foundation
import Combine

protocol NotificationsRepository {
    func getNotifications() -> AnyPublisher<BaseResponse<NotificationsAPIResponse>, Error>
}

class RemoteNotificationsRepository: NotificationsRepository {
    func getNotifications() -> AnyPublisher<BaseResponse<NotificationsAPIResponse>, any Error> {
        return APIClient.performDecodableRequest(route: APIRouter.getNotifications)
    }
}
