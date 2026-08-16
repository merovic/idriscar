//
//  OffersDetailsView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 27/03/2025.
//

import UIKit
import Combine
import CombineCocoa
import BottomSheet

class OffersDetailsView: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: OfferDetailsViewModel?
    
    private let loadingView = LoadingAnimation()

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var offerImage: UIImageView!
    @IBOutlet weak var offerDetailsTextView: UITextView!
    @IBOutlet weak var requestOffer: UIButton!
    
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
        
        requestOffer.tapPublisher
            .sink { _ in
                // offers success
            }
            .store(in: &bindings)
        
        viewModel.$offer
            .sink { [weak self] offer in
                guard let self = self, let offer = offer else { return }
                
                self.offerImage.sd_setImage(with: URL(string: offer.image), placeholderImage: UIImage(named: "offersample"))
                
                //self.displayStyledHTML(from: offer.description ?? "", in: offerDetailsTextView)
                
                let htmlString = offer.description ?? ""
                if let data = htmlString.data(using: .utf8) {
                    do {
                        // Convert HTML to NSAttributedString
                        let attributedString = try NSMutableAttributedString(
                            data: data,
                            options: [
                                .documentType: NSAttributedString.DocumentType.html,
                                .characterEncoding: String.Encoding.utf8.rawValue
                            ],
                            documentAttributes: nil
                        )

                        // Create paragraph style for spacing
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.lineSpacing = 8          // line spacing between lines
                        paragraphStyle.paragraphSpacing = 12    // spacing after paragraphs

                        // Apply font and paragraph style to entire string
                        let fullRange = NSRange(location: 0, length: attributedString.length)
                        attributedString.addAttributes([
                            .font: UIFont.systemFont(ofSize: 18),
                            .paragraphStyle: paragraphStyle
                        ], range: fullRange)

                        // Set to a text view (preferred for HTML-rich text)
                        offerDetailsTextView.attributedText = attributedString
                        offerDetailsTextView.isEditable = false
                        offerDetailsTextView.isScrollEnabled = true

                    } catch {
                        print("Error parsing HTML: \(error)")
                    }
                }
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
