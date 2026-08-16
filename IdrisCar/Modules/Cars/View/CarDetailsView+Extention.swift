//
//  CarDetailsView+Extention.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 24/04/2026.
//

import SDWebImage
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

class WhiteBackgroundRemover: NSObject, SDImageTransformer {
    var transformerKey: String = "white-background-remover"
    
    private let context = CIContext()
    
    func transformedImage(with image: UIImage, forKey key: String) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return image }
        
        // Convert whites → transparent (basic threshold)
        let filter = CIFilter.colorMatrix()
        filter.inputImage = ciImage
        
        // This reduces alpha for bright pixels (tweakable)
        filter.rVector = CIVector(x: 1, y: 0, z: 0, w: 0)
        filter.gVector = CIVector(x: 0, y: 1, z: 0, w: 0)
        filter.bVector = CIVector(x: 0, y: 0, z: 1, w: 0)
        filter.aVector = CIVector(x: -1, y: -1, z: -1, w: 1.5) // key trick
        
        guard let output = filter.outputImage,
              let cgImage = context.createCGImage(output, from: output.extent) else {
            return image
        }
        
        return UIImage(cgImage: cgImage)
    }
}
