//
//  TermsView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 18/06/2025.
//

import UIKit

class TermsView: UIViewController {
    
    var viewModel: TermsViewModel?
    
    private let loadingView = LoadingAnimation()

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var termsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindViews()
    }
    
    func BindViews(){
        guard let viewModel = viewModel else { return }
        
        viewModel.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &viewModel.cancellables)
        
        viewModel.$errorMessage
            .compactMap { $0.isEmpty ? nil : $0 }
            .sink { errorMessage in
                ToastManager.shared.showToast(
                    iconName: "erroricon",
                    titleText: "Terms",
                    subtitleText: errorMessage,
                    hapticFeedback: .notification(type: .error)
                )
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.$terms
            .compactMap { $0.isEmpty ? nil : $0 }
            .sink { [self] termsHTMLText in
                let htmlString = termsHTMLText
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
                        termsTextView.attributedText = attributedString
                        termsTextView.isEditable = false
                        termsTextView.isScrollEnabled = true

                    } catch {
                        print("Error parsing HTML: \(error)")
                    }
                }
            }
            .store(in: &viewModel.cancellables)
        
        backButton.tapPublisher
            .sink {
                viewModel.popView()
            }
            .store(in: &viewModel.cancellables)
    }
}
