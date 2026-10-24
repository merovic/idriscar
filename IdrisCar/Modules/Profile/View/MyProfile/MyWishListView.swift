//
//  MyWishListView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 04/06/2025.
//

import UIKit
import SwiftUI
import Combine

class MyWishListView: UIViewController {
        
    var viewModel: MyWishListViewModel?
    
    @IBOutlet weak var removeAllButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AttachViews()
        BindViews()
    }
    
    func AttachViews() {
        guard let viewModel = viewModel else { return }
        self.container.EmbedSwiftUIView(
            view: MyWishListSwiftUIView(viewModel: viewModel).environmentObject(CarFavoritesManager.shared),
            parent: self)
    }
    
    func BindViews(){
        guard let viewModel = viewModel else { return }
        
        viewModel.$errorMessage
            .compactMap { $0.isEmpty ? nil : $0 }
            .sink { errorMessage in
                ToastManager.shared.showToast(
                    iconName: "erroricon",
                    titleText: "Car Requests".localized,
                    subtitleText: errorMessage,
                    hapticFeedback: .notification(type: .error)
                )
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.$wishList
            .sink { [self] list in
                removeAllButton.isHidden = list.isEmpty
            }
            .store(in: &viewModel.cancellables)
        
        removeAllButton.tapPublisher
            .sink {
                viewModel.removeAll()
            }
            .store(in: &viewModel.cancellables)
        
        backButton.tapPublisher
            .sink {
                viewModel.popView()
            }
            .store(in: &viewModel.cancellables)
    }
}

struct MyWishListSwiftUIView: View {
    @ObservedObject var viewModel: MyWishListViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            if viewModel.isAnimating && viewModel.wishList.isEmpty {
                VStack(spacing: 10) {
                    ForEach((0..<4).map { "wishlist-skeleton-\($0)" }, id: \.self) { _ in
                        CarSkeletonItemView()
                    }
                }
                .padding(.vertical)
            } else if viewModel.wishList.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "heart.slash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)
                    
                    Text("Your wishlist is empty.")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text("Start adding cars you like to your wishlist!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .padding(.top, 100)
                .frame(maxWidth: .infinity)
            } else {
                VStack {
                    ForEach(viewModel.wishList, id: \.id) { car in
                        CarItemView(car: car, onCarSelected: {
                            viewModel.goToRequestCar(carID: car.id)
                        }, onFavoriteClicked: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                viewModel.getWishList()
                            }
                        })
                    }
                }
                .padding(.vertical)
            }
        }
    }
}
