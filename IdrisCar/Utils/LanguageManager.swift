//
//  LanguageManager.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 20/06/2026.
//

import Foundation
import SwiftUI
import UIKit

final class LanguageManager: ObservableObject {

    static let shared = LanguageManager()

    static let storageKey = "AppLanguage"

    @Published var languageCode: String

    private init() {
        languageCode =
            UserDefaults.standard.string(
                forKey: Self.storageKey
            ) ?? "en"
        applyLanguageSettings()
    }

    func setLanguage(_ code: String) {
        languageCode = code
        UserDefaults.standard.set(
            code,
            forKey: Self.storageKey
        )
        UserDefaults.standard.set([code], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        LoginDataService.shared.setAppLanguage(AppLanguage(name: localizedLanguageName(for: code), code: code))
        applyLanguageSettings()
    }

    var isArabic: Bool {
        languageCode.hasPrefix("ar")
    }

    var isRTL: Bool {
        Locale.Language(identifier: languageCode).characterDirection == .rightToLeft
    }

    var currentLocaleIdentifier: String {
        languageCode
    }

    var locale: Locale {
        Locale(identifier: languageCode)
    }

    var semanticContentAttribute: UISemanticContentAttribute {
        isRTL ? .forceRightToLeft : .forceLeftToRight
    }

    private var localizedBundle: Bundle {
        guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return .main
        }
        return bundle
    }

    func localizedString(for key: String) -> String {
        localizedBundle.localizedString(forKey: key, value: nil, table: nil)
    }

    func applyLanguageSettings() {
        let direction = semanticContentAttribute
        UIView.appearance().semanticContentAttribute = direction
        UINavigationBar.appearance().semanticContentAttribute = direction
        UITabBar.appearance().semanticContentAttribute = direction

        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .forEach { window in
                applySemanticContentAttribute(direction, to: window)
                window.rootViewController?.view.semanticContentAttribute = direction
                window.setNeedsLayout()
                window.layoutIfNeeded()
            }
    }

    private func applySemanticContentAttribute(_ direction: UISemanticContentAttribute, to view: UIView) {
        view.semanticContentAttribute = direction
        view.subviews.forEach { applySemanticContentAttribute(direction, to: $0) }
    }

    private func localizedLanguageName(for code: String) -> String {
        code.hasPrefix("ar") ? "Arabic".localized : "English".localized
    }
}
