//
//  CarDetailsView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 25/03/2025.
//

import UIKit
import SwiftUI
import Combine
import CombineCocoa
import SDWebImageSwiftUI

class CarDetailsView: UIViewController {
    
    var viewModel: CarDetailsViewModel?
    
    private let loadingView = LoadingAnimation()
    
    @IBOutlet weak var mainContainer: UIView!
    
    @IBOutlet weak var priceBeforeLabel: UILabel!
    @IBOutlet weak var priceBeforeStack: UIStackView!
    @IBOutlet weak var priceAfterLabel: UILabel!
    
    @IBOutlet weak var priceAfterStack: UIStackView!
    @IBOutlet weak var footerContainer: UIView!
    @IBOutlet weak var footerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var requestCarButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var requestCarButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var priceLabelButtonSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var priceStackButtonSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var priceLabel: UILabel! {
        didSet {
            priceLabel.text = "Price".localized
        }
    }
    @IBOutlet weak var requestCarButton: UIButton! {
        didSet {
            requestCarButton.setTitle("Request a Car".localized, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AttachViews()
        BindViews()
        updateRequestCarButtonVisibility()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateRequestCarButtonVisibility()
    }
    
    func AttachViews() {
        self.mainContainer.EmbedSwiftUIView(view: CarDetailsSwiftUIView(viewModel: viewModel!).environmentObject(CarFavoritesManager.shared), parent: self)
    }
    
    func BindViews(){
        guard let viewModel = viewModel else { return }
        
        viewModel.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &viewModel.cancellables)
        
        viewModel.$backPressed
            .sink { [weak self] state in
                guard let self = self else { return }
                if state {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.$comparisonPressed
            .dropFirst()
            .sink { [weak self] _ in
                guard let self = self else { return }
                let vc = ComparisonView()
                let comparisonViewModel = ComparisonViewModel()
                vc.hidesBottomBarWhenPushed = true
                vc.viewModel = comparisonViewModel

                comparisonViewModel.onRequestClicked = { [weak self] car in
                    guard let mainViewModel = self?.viewModel else { return }
                    mainViewModel.goToRequestCarFlowSpecific(car: car)
                }

                self.navigationController?.pushViewController(vc, animated: true)
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.$car
            .sink { [weak self] car in
                guard let self = self else { return }
                
                if let oldPrice = car?.oldPrice {
                    priceBeforeLabel.text = oldPrice
                }
                priceBeforeStack.isHidden = car?.oldPrice == nil
                
                if let price = car?.price {
                    priceAfterLabel.text = String(price)
                }
                priceAfterStack.isHidden = car?.price == nil
                priceLabel.isHidden = car?.oldPrice == nil && car?.price == nil
                
                updateRequestCarButtonVisibility()
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.$selectedColor
            .sink { [weak self] color in
                guard self != nil else { return }
                viewModel.carImage = color?.image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.$albumClicked
            .sink { [weak self] clicked in
                guard self != nil else { return }
                if clicked {
                    let vc = CarGalleryView()
                    vc.hidesBottomBarWhenPushed = true
                    vc.viewModel = CarGalleryViewModel(albums: viewModel.car?.albums ?? [])
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            .store(in: &viewModel.cancellables)
        
        requestCarButton.tapPublisher
            .sink { _ in
                viewModel.goToRequestCarFlow()
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func updateRequestCarButtonVisibility() {
        let isLoggedIn = LoginDataService.shared.isLoggedIn()
        let hasPriceContent = viewModel?.car?.oldPrice != nil || viewModel?.car?.price != nil
        let footerHeight: CGFloat
        let spacing: CGFloat = isLoggedIn && hasPriceContent ? 20 : 0
        
        switch (isLoggedIn, hasPriceContent) {
        case (true, true):
            footerHeight = 167
        case (true, false), (false, true):
            footerHeight = 90
        case (false, false):
            footerHeight = 0
        }
        
        requestCarButton.isHidden = !isLoggedIn
        footerContainer.isHidden = footerHeight == 0
        footerHeightConstraint.constant = footerHeight
        requestCarButtonHeightConstraint.constant = isLoggedIn ? 60 : 0
        requestCarButtonBottomConstraint.constant = footerHeight == 0 ? 0 : 30
        priceLabelButtonSpacingConstraint.constant = spacing
        priceStackButtonSpacingConstraint.constant = spacing
        
        view.layoutIfNeeded()
    }
}

struct CarDetailsSwiftUIView: View {
    
    @ObservedObject var viewModel: CarDetailsViewModel
    @EnvironmentObject var favoritesManager: CarFavoritesManager
    
    private var isFavorite: Bool {
        guard let car = viewModel.car else { return false }
        return favoritesManager.isFavorite(car)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 10) {
                
                // Header & Image & Colors
                VStack(spacing: 0){
                    headerView
                    carImageView
                    ColorsSwiftUIView(viewModel: viewModel)
                }
        
                // Car Info & Description
                VStack(alignment: .leading, spacing: 15) {
                    carBasicInfoView
                    carDescriptionView
                    segmentedControlView
                    selectedContentView
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            IconButton(imageName: .asset("backButtonWhite")) {
                viewModel.backPressed.toggle()
            }
            Spacer()
            IconButton(imageName: .asset("Compare")) {
                guard let car = viewModel.car else { return }
                CarsDataService.shared.saveCarToCompare(car)
                viewModel.comparisonPressed.toggle()
            }
            IconButton(imageName: isFavorite ? .system("heart.fill") : .system("heart")) {
                guard let car = viewModel.car else { return }
                favoritesManager.toggleFavorite(car)
            }
        }
        .padding(.horizontal)
    }
    
    private var carImageView: some View {
        WebImage(url: URL(string: viewModel.carImage))
            .resizable()
            .indicator(.activity)
            .aspectRatio(contentMode: .fit)
            .frame(height: 200)
            .padding(.horizontal)
    }
    
    private var carBasicInfoView: some View {
        HStack(spacing: 10) {
            InfoTextView(title: "Brand:".localized, value: viewModel.car?.brand)
            InfoTextView(title: "Model:".localized, value: viewModel.car?.model)
        }
        .padding(.horizontal)
    }
    
    private var carDescriptionView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(viewModel.car?.name ?? "")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
            
            Text(viewModel.car?.description?.htmlToString ?? "")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }
    
    private var segmentedControlView: some View {
        CustomSegmentedControlView(
            selectedIndex: $viewModel.selectedType,
            items: ["Gallery".localized, "Features".localized],
            height: 55
        )
    }
    
    @ViewBuilder
    private var selectedContentView: some View {
        if viewModel.selectedType == 0 {
            GallerySwiftUIView(viewModel: viewModel)
        } else {
            PropertiesSwiftUIView(viewModel: viewModel)
        }
    }
}

// MARK: - Components

struct IconButton: View {
    
    @Environment(\.layoutDirection) var layoutDirection

    enum Icon {
        case asset(String)
        case system(String)
    }

    let imageName: Icon
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Group {
                switch imageName {
                case .asset(let name):
                    Image(name)
                        .resizable()
                        .rotationEffect(layoutDirection == .rightToLeft ? .degrees(180) : .degrees(0))

                case .system(let name):
                    Image(systemName: name)
                        .resizable()
                        .scaledToFit()
                        .padding(12)
                }
            }
            .frame(width: 48, height: 48)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

struct InfoTextView: View {
    let title: String
    let value: String?
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black)
            Text(value ?? "")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray)
        }
    }
}

struct ColorsSwiftUIView: View {
    @ObservedObject var viewModel: CarDetailsViewModel

    var body: some View {
        if let colors = viewModel.car?.colors {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(colors) { color in
                        ColorItemSwiftUIView(selectedColor: $viewModel.selectedColor, color: color)
                            .onTapGesture {
                                viewModel.selectedColor = color
                            }
                    }
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 20)
        }
    }
}

struct ColorItemSwiftUIView: View {
    @Binding var selectedColor: ColorItem?
    var color: ColorItem?
    
    var body: some View {
        WebImage(url: URL(string: color?.image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
            .resizable()
            .indicator(.activity)
            .aspectRatio(contentMode: .fit)
            .frame(width: 58, height: 46)
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .cornerRadius(2)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(selectedColor == color ? Color("AccentColor") : Color("BorderColor"), lineWidth: 1)
            )
    }
}

struct GallerySwiftUIView: View {
    @ObservedObject var viewModel: CarDetailsViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            if let albums = viewModel.car?.albums {
                ForEach(0..<albums.count, id: \.self) { index in
                    GalleryItemView(album: albums[index])
                        .onTapGesture {
                            viewModel.albumClicked = true
                        }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 14)
    }
}

struct GalleryItemView: View {
    var album: Album
    
    var body: some View {
        HStack(alignment: .top) {
            WebImage(url: URL(string: album.images.first?.image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
                .resizable()
                .indicator(.activity)
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 120)
                .cornerRadius(4)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(album.name)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                Text(album.description ?? "")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Spacer()
            }
            Spacer()
        }
        .padding(10)
        .cornerRadius(4)
        .frame(maxWidth: .infinity, minHeight: 136)
    }
}

struct PropertiesSwiftUIView: View {
    @State private var expandedItems: Set<UUID> = []
    @ObservedObject var viewModel: CarDetailsViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(viewModel.car?.featuresGroups ?? []) { group in
                    featureGroupView(group: group)
                }
                Spacer()
            }
            .padding(.vertical)
        }
    }
    
    private func featureGroupView(group: FeaturesGroup) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: { toggleGroup(group.id) }) {
                HStack {
                    Text(group.groupName)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: expandedItems.contains(group.id) ? "chevron.down" : "chevron.forward")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
            }
            
            if expandedItems.contains(group.id) {
                ForEach(Array(group.features.enumerated()), id: \.element.id) { index, feature in
                    HStack {
                        Text(feature.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text((feature.value?.isEmpty ?? true) ? "-" : feature.value!)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .font(.system(size: 14))
                    .padding(.horizontal)
                    .frame(height: 42)
                    .background(index.isMultiple(of: 2) ? Color("LightRed").opacity(0.2) : Color.clear)
                }
            }
            Divider()
                .padding(.top, 8)
        }
        .padding(.horizontal)
    }
    
    private func toggleGroup(_ id: UUID) {
        if expandedItems.contains(id) {
            expandedItems.remove(id)
        } else {
            expandedItems.insert(id)
        }
    }
}


struct CustomSegmentedControlView: View {
    @Binding var selectedIndex: Int
    var items: [String]
    var height: CGFloat = 45

    var body: some View {
        HStack(spacing: 0) {
            ForEach(items.indices, id: \.self) { index in
                Button(action: {
                    selectedIndex = index
                }) {
                    Text(items[index])
                        .font(.system(size: 16, weight: selectedIndex == index ? .semibold : .regular))
                        .foregroundColor(selectedIndex == index ? .white : .gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(selectedIndex == index ? Color.accent : Color("BackgroundGray"))
                }
            }
        }
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.accent, lineWidth: 0)
        )
        .padding(.horizontal)
    }
}
