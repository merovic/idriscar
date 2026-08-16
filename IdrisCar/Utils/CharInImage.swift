//
//  CharInImage.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 22/05/2025.
//

import UIKit

extension UIImage {
    static func fromInitial(
        _ name: String,
        size: CGFloat = 60,
        backgroundColor: UIColor = .systemBlue,
        textColor: UIColor = .white,
        font: UIFont? = nil
    ) -> UIImage {
        let initial = String(name.prefix(1)).uppercased()
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))

        return renderer.image { _ in
            // Draw circular background
            let circlePath = UIBezierPath(ovalIn: CGRect(origin: .zero, size: CGSize(width: size, height: size)))
            backgroundColor.setFill()
            circlePath.fill()

            // Draw the initial
            let textFont = font ?? UIFont.systemFont(ofSize: size / 2, weight: .bold)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: textFont,
                .foregroundColor: textColor
            ]

            let textSize = initial.size(withAttributes: attributes)
            let rect = CGRect(
                x: (size - textSize.width) / 2,
                y: (size - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            initial.draw(in: rect, withAttributes: attributes)
        }
    }
}
