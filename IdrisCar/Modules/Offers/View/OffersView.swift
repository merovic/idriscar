//
//  OffersView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 27/03/2025.
//

import UIKit
import SwiftUI
import Combine

class OffersView: UIViewController {
        
    var viewModel: OffersViewModel?
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var searchBar: UITextField!
    
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AttachViews()
        BindViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let viewModel = viewModel else { return }
        viewModel.getOffers()
    }
    
    func AttachViews() {
        self.container.EmbedSwiftUIView(view: OffersSwiftUIView(viewModel: viewModel!), parent: self)
    }
    
    func BindViews(){
        guard let viewModel = viewModel else { return }

        viewModel.$isBackButtonVisible
            .receive(on: DispatchQueue.main)
            .map { !($0 ?? false) }
            .assign(to: \.isHidden, on: backButton)
            .store(in: &viewModel.cancellables)
        
        backButton.tapPublisher
            .sink { _ in
                viewModel.pop()
            }
            .store(in: &viewModel.cancellables)
    }
}

struct OffersSwiftUIView: View {
    
    @ObservedObject var viewModel: OffersViewModel
    
    var body: some View {
        Group {
            if viewModel.isAnimating && viewModel.offers.isEmpty {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 10) {
                        ForEach((0..<4).map { "offers-list-skeleton-\($0)" }, id: \.self) { _ in
                            OfferSkeletonItemView()
                        }
                    }
                    .padding(.vertical)
                }
            } else if viewModel.offers.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "tray")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    
                    Text("No offers available")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 10) {
                        ForEach(viewModel.offers.indices, id: \.self) { index in
                            OfferItemView(offer: viewModel.offers[index]) {
                                viewModel.selectedOfferID = viewModel.offers[index].id
                                viewModel.goToOfferDetails()
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
    }
}
