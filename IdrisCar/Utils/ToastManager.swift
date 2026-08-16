//
//  ToastManager.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 24/05/2025.
//

import UIKit
import CxjToasts

final class ToastManager {
    
    static let shared = ToastManager()
    
    private init() {}
    
    func showToast(
        iconName: String? = nil,
        titleText: String,
        subtitleText: String? = nil,
        hapticFeedback: CxjHapticFeedback? = nil,
        backgroundColor: UIColor = .white
    ) {
        DispatchQueue.main.async {
            let iconConfig: CxjIconConfiguration? = {
                if let iconName = iconName, let image = UIImage(named: iconName) {
                    return CxjIconConfiguration(
                        icon: image,
                        fixedSize: .init(width: 30, height: 30)
                    )
                }
                return nil
            }()
            
            let title = CxjTextConfiguration.plain(
                string: titleText,
                attributes: .init(textColor: .accent, font: UIFont.systemFont(ofSize: 16, weight: .semibold))
            )
            
            let subtitle: CxjTextConfiguration? = {
                if let subtitleText = subtitleText {
                    return CxjTextConfiguration.plain(
                        string: subtitleText,
                        attributes: .init(textColor: UIColor.gray, font: UIFont.systemFont(ofSize: 14))
                    )
                }
                return nil
            }()
            
            let data = CxjToastTemplate.NativeToastData(
                typeId: CxjToastTypeid(""),
                title: title,
                subtitle: subtitle,
                icon: iconConfig,
                background: .colorized(color: backgroundColor),
                shadow: .disable,
                hapticFeeback: hapticFeedback
            )
            
            let template = CxjToastTemplate.native(data: data)
            
            CxjToastsCoordinator.shared.showToast(type: .templated(template: template), animated: true)
            
            if let haptic = hapticFeedback {
                self.triggerNativeHaptic(haptic)
            }
        }
    }
    
    private func triggerNativeHaptic(_ feedback: CxjHapticFeedback) {
        switch feedback {
        case .notification(let type):
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        case .uiImpact(let style):
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.prepare()
            generator.impactOccurred()
        case .custom(let generator):
            // Handle custom feedback if implemented
            print("Custom haptic feedback triggered")
        }
    }
}
