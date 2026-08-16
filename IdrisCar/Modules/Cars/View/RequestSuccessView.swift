//
//  RequestSuccessView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 27/03/2025.
//

import UIKit
import SnapKit

protocol RequestBottomSheetDelegate {
    func clickAssigned()
}

class RequestSuccessView: UIViewController {
    
    var delegate: RequestBottomSheetDelegate!

    private var currentHeight: CGFloat {
        didSet {
            updatePreferredContentSize()
        }
    }

    private let _scrollView = UIScrollView()
    
    // MARK: - Init

    init(initialHeight: CGFloat) {
        self.currentHeight = initialHeight
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePreferredContentSize()
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        self.delegate.clickAssigned()
        self.dismiss(animated: true)
    }
    
    
    // MARK: - Private methods
    private func updatePreferredContentSize() {
        _scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: currentHeight)
        preferredContentSize = _scrollView.contentSize
    }

    private func updateContentHeight(newValue: CGFloat) {
        guard newValue >= 200, newValue < 5000 else { return }

        let updates = { [self] in
            currentHeight = newValue
            updatePreferredContentSize()
        }

        if navigationController == nil {
            UIView.animate(withDuration: 0.25, animations: updates)
        } else {
            updates()
        }
    }
    
    // MARK: - Setup
    private func setupSubviews() {
        view.backgroundColor = .white
        view.addSubview(_scrollView)

        // Enable Auto Layout
        _scrollView.translatesAutoresizingMaskIntoConstraints = false

        // Set constraints
        NSLayoutConstraint.activate([
            _scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            _scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            _scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            _scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        _scrollView.alwaysBounceVertical = true
    }

}
