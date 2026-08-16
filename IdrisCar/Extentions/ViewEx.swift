//
//  ViewEx.swift
//  Abshare
//
//  Created by Apple on 06/10/2021.
//

import UIKit

extension UIView{
    
    func roundedMinorHareefView(){
        self.layer.masksToBounds = false
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 6
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.1897802949, green: 0.6920717359, blue: 0.7039652467, alpha: 1)
    }
    
    func roundedHareefView(){
        self.layer.masksToBounds = false
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.1897802949, green: 0.6920717359, blue: 0.7039652467, alpha: 1)
    }
    
    func roundedGrayHareefView(){
        self.layer.masksToBounds = false
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.9387457371, green: 0.9387457371, blue: 0.9387457371, alpha: 1)
    }
    
    func roundedRedHareefView(){
        self.layer.masksToBounds = false
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
    }
    
    func roundedBlackHareefView(){
        self.layer.masksToBounds = false
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func roundedLightGrayHareefView(){
        self.layer.masksToBounds = false
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.8107264638, green: 0.8107264638, blue: 0.8107264638, alpha: 1)
    }
    
    func roundedWhiteHareefView(){
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1.5
        self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func roundedExtraHareefView(){
        self.layer.masksToBounds = false
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1.5
        self.layer.borderColor = #colorLiteral(red: 0.1897802949, green: 0.6920717359, blue: 0.7039652467, alpha: 1)
    }
    
    func roundedRosovinaLight(){
        self.layer.masksToBounds = false
        self.backgroundColor = UIColor.init(named: "LightGray")
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
    func roundedRosovinaDark(){
        self.layer.masksToBounds = false
        self.backgroundColor = UIColor.init(named: "OnionColor")
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1.5
        self.layer.borderColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
    }
    
    func rounded(){
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 10
    }
}

@IBDesignable extension UIView {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}


extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}


extension UIImageView {
    func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 5)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 1.0
        self.clipsToBounds = false
    }
}

@IBDesignable
class StrikethroughLabel: UILabel {

    @IBInspectable var isStrikethrough: Bool = false {
        didSet {
            applyStrikethrough()
        }
    }

    private func applyStrikethrough() {
        guard let labelText = text else { return }
        let attributedText = NSMutableAttributedString(string: labelText)

        if isStrikethrough {
            attributedText.addAttribute(.strikethroughStyle,
                                        value: NSUnderlineStyle.single.rawValue,
                                        range: NSRange(location: 0, length: labelText.count))
            attributedText.addAttribute(.strikethroughColor,
                                        value: textColor ?? UIColor.black,
                                        range: NSRange(location: 0, length: labelText.count))
        }

        self.attributedText = attributedText
    }

    override var text: String? {
        didSet {
            applyStrikethrough()
        }
    }
}
