//
//  StringProtocolEx.swift
//  Hareef-Captain
//
//  Created by Amir Ahmed on 02/03/2024.
//

import Foundation
import UIKit

extension StringProtocol {
    func startcased() -> String {
        components(separatedBy: " ")
            .map { $0.prefix(1).uppercased() + $0.dropFirst() }
            .joined(separator: " ")
    }
}

public extension UILabel {
    @IBInspectable var localizeKey: String? {
        get {
            return text
        }
        set {
            text = (newValue ?? "").localized
        }
    }
}

public extension UILabel {
    @IBInspectable var localizedText: String? {
        get { nil }
        set {
            guard let key = newValue, !key.isEmpty else { return }
            text = key.localized
        }
    }
}

public extension UIButton {
    @IBInspectable var localizeKey: String? {
        get {
            return titleLabel?.text
        }
        set {
            setTitle((newValue ?? "").localized, for: .normal)
        }
    }
}

public extension UIButton {
    @IBInspectable var localizedText: String? {
        get { nil }
        set {
            guard let key = newValue, !key.isEmpty else { return }

            let title = key.localized

            setTitle(title, for: .normal)
            setTitle(title, for: .highlighted)
            setTitle(title, for: .selected)
        }
    }
}

public extension UITextField {
    @IBInspectable var localizeKey: String? {
        get {
            return placeholder
        }
        set {
            placeholder = (newValue ?? "").localized
        }
    }
}

public extension UITextField {
    @IBInspectable var localizedText: String? {
        get { nil }
        set {
            guard let key = newValue, !key.isEmpty else { return }
            placeholder = key.localized
        }
    }
}
