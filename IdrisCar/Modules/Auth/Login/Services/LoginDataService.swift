//
//  LoginDataService.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 06/05/2025.
//

import Foundation

final class LoginDataService {
    
    // MARK: - Singleton
    static let shared = LoginDataService()
    private init() {}
    
    // MARK: - UserDefaults Keys
    private struct Keys {
        static let loginResponse               = "loginResponse"
        static let authToken                   = "authToken"
        static let isLoggedIn                  = "isLoggedIn"
        static let firebaseToken               = "firebaseToken"
        static let hasBeenLaunchedBeforeFlag   = "hasBeenLaunchedBeforeFlag"
        static let appLanguage                 = "appLanguage"
    }
    
    // MARK: - Constants
    static let googleApiKey = "AIzaSyCCiAbMIfF_IpdCxFKB7CZTgqbJrlOc09o"
    
    private let defaults = UserDefaults.standard
    
    // MARK: - Login Management
    
    func setLogin() {
        defaults.set(true, forKey: Keys.isLoggedIn)
    }
    
    func setLogout() {
        defaults.set(false, forKey: Keys.isLoggedIn)
        clearUserData()
    }
    
    func isLoggedIn() -> Bool {
        defaults.bool(forKey: Keys.isLoggedIn)
    }
    
    // MARK: - First Launch Management
    
    @discardableResult
    func setFirstLaunchFromTermination() -> Bool {
        let isFirstLaunch = !defaults.bool(forKey: Keys.hasBeenLaunchedBeforeFlag)
        if isFirstLaunch {
            defaults.set(true, forKey: Keys.hasBeenLaunchedBeforeFlag)
            defaults.synchronize()
        }
        return isFirstLaunch
    }
    
    // MARK: - App Language
    
    func setAppLanguage(_ language: AppLanguage) {
        do {
            let data = try JSONEncoder().encode(language)
            defaults.set(data, forKey: Keys.appLanguage)
        } catch {
            print("Failed to encode AppLanguage: \(error)")
        }
    }
    
    func getAppLanguage() -> AppLanguage {
        guard let data = defaults.data(forKey: Keys.appLanguage) else {
            return AppLanguage(name: "english".localized, code: "en")
        }
        do {
            return try JSONDecoder().decode(AppLanguage.self, from: data)
        } catch {
            print("Failed to decode AppLanguage: \(error)")
            return AppLanguage(name: "english".localized, code: "en")
        }
    }
    
    // MARK: - Firebase Token
    
    func setFirebaseToken(_ token: String) {
        defaults.set(token, forKey: Keys.firebaseToken)
    }
    
    func getFirebaseToken() -> String {
        defaults.string(forKey: Keys.firebaseToken) ?? ""
    }
    
    func setUserData(_ data: LoginAPIResponse) {
        KeychainManager.shared.save(data, forKey: Keys.loginResponse)
    }
    
    func getUserData() -> LoginAPIResponse? {
        KeychainManager.shared.get(forKey: Keys.loginResponse, as: LoginAPIResponse.self)
    }
    
    func clearUserData() {
        KeychainManager.shared.delete(forKey: Keys.loginResponse)
    }
}
