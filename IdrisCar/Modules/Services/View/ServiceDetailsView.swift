//
//  ServiceDetailsView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 27/03/2025.
//

import UIKit
import Combine
import CombineCocoa
import BottomSheet
import SDWebImage

class ServiceDetailsView: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: ServiceDetailsViewModel?
    
    private let loadingView = LoadingAnimation()

    @IBOutlet weak var serviceImage: UIImageView!
    @IBOutlet weak var serviceDescription: UITextView!
    
    @IBOutlet weak var serviceAddionalDetails: UITextView!
    
    @IBOutlet weak var servicePriceBefore: UILabel!
    @IBOutlet weak var servicePrice: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var requestService: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindViews()
    }
    
    func BindViews(){
        guard let viewModel = viewModel else { return }
        
        viewModel.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &bindings)
        
        backButton.tapPublisher
            .sink { _ in
                viewModel.pop()
            }
            .store(in: &bindings)
        
        favoriteButton.tapPublisher
            .sink { _ in
                
            }
            .store(in: &bindings)
        
        serviceAddionalDetails.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.serviceAddionalDetails, on: viewModel)
        .store(in: &bindings)
        
        requestService.tapPublisher
            .sink { _ in
                viewModel.requestService()
            }
            .store(in: &bindings)
        
        viewModel.$service
            .sink { [weak self] service in
                guard let self = self, let service = service else { return }
                
                self.serviceImage.sd_setImage(with: URL(string: service.image), placeholderImage: UIImage(named: "offersample"))
                self.servicePrice.text = String(service.price ?? 0)
                self.servicePriceBefore.text = String(service.oldPrice ?? 0)
                
                self.displayStyledHTML(from: service.description ?? "", in: self.serviceDescription)
            }
            .store(in: &bindings)
    }
    
    func displayStyledHTML(from backendHTML: String, in textView: UITextView) {
        let style = """
        <style>
            body {
                font-family: -apple-system, Helvetica, Arial, sans-serif;
                font-size: 16px;
                color: #333333;
                line-height: 1.6;
                padding: 0;
                margin: 0;
            }

            h1, h2, h3, h4, h5, h6, strong {
                font-weight: bold;
                color: #000000;
                font-size: 17px;
                margin-top: 28px;    /* Increased top spacing */
                margin-bottom: 12px; /* Increased bottom spacing */
                display: block;
            }

            p {
                margin-top: 0;
                margin-bottom: 16px;
            }

            ul {
                padding-left: 20px;
                margin-top: 0;
                margin-bottom: 16px;
            }

            li {
                margin-bottom: 8px;
            }

            pre {
                background-color: transparent;
                padding: 0;
                font-family: Menlo, Courier, monospace;
                font-size: 14px;
                white-space: pre-wrap;
            }
        </style>
        """

        let finalHTML = "<html><head>\(style)</head><body>\(backendHTML)</body></html>"

        if let data = finalHTML.data(using: .utf8) {
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ]

            do {
                let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
                textView.attributedText = attributedString
                textView.isEditable = false
                textView.isScrollEnabled = true
            } catch {
                print("Failed to load styled HTML: \(error)")
            }
        }
    }
}
