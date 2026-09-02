//
//  ToastManager.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 24/05/2025.
//

import UIKit

enum ToastHapticFeedback {
    case notification(type: UINotificationFeedbackGenerator.FeedbackType)
    case uiImpact(style: UIImpactFeedbackGenerator.FeedbackStyle)
}

final class ToastManager {
    
    static let shared = ToastManager()
    
    private weak var currentToastView: UIView?
    private var hideWorkItem: DispatchWorkItem?
    
    private init() {}
    
    func showToast(
        iconName: String? = nil,
        titleText: String,
        subtitleText: String? = nil,
        hapticFeedback: ToastHapticFeedback? = nil,
        backgroundColor: UIColor = .white
    ) {
        DispatchQueue.main.async {
            guard let window = self.keyWindow else { return }
            
            if let haptic = hapticFeedback {
                self.triggerNativeHaptic(haptic)
            }
            
            self.hideWorkItem?.cancel()
            self.currentToastView?.removeFromSuperview()
            
            let toastView = self.makeToastView(
                iconName: iconName,
                titleText: titleText,
                subtitleText: subtitleText,
                backgroundColor: backgroundColor
            )
            
            window.addSubview(toastView)
            toastView.translatesAutoresizingMaskIntoConstraints = false
            
            let topConstraint = toastView.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: 12)
            NSLayoutConstraint.activate([
                topConstraint,
                toastView.centerXAnchor.constraint(equalTo: window.centerXAnchor),
                toastView.leadingAnchor.constraint(greaterThanOrEqualTo: window.leadingAnchor, constant: 16),
                toastView.trailingAnchor.constraint(lessThanOrEqualTo: window.trailingAnchor, constant: -16),
                toastView.widthAnchor.constraint(lessThanOrEqualToConstant: 360)
            ])
            
            toastView.alpha = 0
            toastView.transform = CGAffineTransform(translationX: 0, y: -16)
            
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut]) {
                toastView.alpha = 1
                toastView.transform = .identity
            }
            
            self.currentToastView = toastView
            
            let workItem = DispatchWorkItem { [weak self, weak toastView] in
                guard let self, let toastView else { return }
                self.dismissToast(toastView)
            }
            self.hideWorkItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + self.displayDuration(for: subtitleText), execute: workItem)
        }
    }
    
    private var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
    
    private func makeToastView(
        iconName: String?,
        titleText: String,
        subtitleText: String?,
        backgroundColor: UIColor
    ) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = backgroundColor
        containerView.layer.cornerRadius = 14
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.12
        containerView.layer.shadowRadius = 12
        containerView.layer.shadowOffset = CGSize(width: 0, height: 6)
        
        let contentStackView = UIStackView()
        contentStackView.axis = .horizontal
        contentStackView.alignment = .top
        contentStackView.spacing = 10
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.layoutMargins = UIEdgeInsets(top: 12, left: 14, bottom: 12, right: 14)
        
        if let iconName, let image = UIImage(named: iconName) {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            contentStackView.addArrangedSubview(imageView)
        }
        
        let textStackView = UIStackView()
        textStackView.axis = .vertical
        textStackView.alignment = .fill
        textStackView.spacing = 4
        
        let titleLabel = UILabel()
        titleLabel.text = titleText
        titleLabel.textColor = .accent
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        
        textStackView.addArrangedSubview(titleLabel)
        
        if let subtitleText, !subtitleText.isEmpty {
            let subtitleLabel = UILabel()
            subtitleLabel.text = subtitleText
            subtitleLabel.textColor = .gray
            subtitleLabel.font = UIFont.systemFont(ofSize: 14)
            subtitleLabel.numberOfLines = 0
            subtitleLabel.lineBreakMode = .byWordWrapping
            textStackView.addArrangedSubview(subtitleLabel)
        }
        
        contentStackView.addArrangedSubview(textStackView)
        containerView.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleToastTap(_:)))
        containerView.addGestureRecognizer(tapGesture)
        
        return containerView
    }
    
    private func displayDuration(for subtitleText: String?) -> TimeInterval {
        guard let subtitleText else { return 3 }
        return subtitleText.count > 90 ? 5 : 3.5
    }
    
    @objc private func handleToastTap(_ gesture: UITapGestureRecognizer) {
        guard let toastView = gesture.view else { return }
        hideWorkItem?.cancel()
        dismissToast(toastView)
    }
    
    private func dismissToast(_ toastView: UIView) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn]) {
            toastView.alpha = 0
            toastView.transform = CGAffineTransform(translationX: 0, y: -12)
        } completion: { _ in
            toastView.removeFromSuperview()
        }
    }
    
    private func triggerNativeHaptic(_ feedback: ToastHapticFeedback) {
        switch feedback {
        case .notification(let type):
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        case .uiImpact(let style):
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.prepare()
            generator.impactOccurred()
        }
    }
}
