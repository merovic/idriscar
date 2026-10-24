//
//  CarsView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 25/03/2025.
//

import UIKit
import SwiftUI
import Combine

class CarsView: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: CarsViewModel?
    
    @IBOutlet weak var backButton: UIButton!

    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AttachViews()
        BindViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let viewModel = viewModel else { return }
        viewModel.getBrands()
        viewModel.getCars()
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func textFieldDidReturn(_ sender: UITextField) {
        let request = CarsAPIRequest(name: sender.text)
        viewModel?.getFilteredCars(request: request)
        sender.resignFirstResponder()
    }
    
    @IBAction func filterPressed(_ sender: Any) {
        guard let viewModel = viewModel else { return }
        viewModel.goToFilter()
    }
    
    func AttachViews() {
        guard let viewModel = viewModel else { return }
        self.container.EmbedSwiftUIView(
            view: CarsSwiftUIView(viewModel: viewModel).environmentObject(CarFavoritesManager.shared),
            parent: self)
    }
    
    func BindViews() {
        guard let viewModel = viewModel else { return }
        viewModel.$isBackButtonVisible
            .receive(on: DispatchQueue.main)
            .map { !($0 ?? false) }
            .assign(to: \.isHidden, on: backButton)
            .store(in: &bindings)
        
        searchTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.searchText, on: viewModel)
            .store(in: &bindings)
    }
}


struct CarsSwiftUIView: View {
    
    @ObservedObject var viewModel: CarsViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        if viewModel.isAnimating && viewModel.brands.isEmpty {
                            ForEach((0..<5).map { "cars-brand-skeleton-\($0)" }, id: \.self) { _ in
                                ShimmerSkeletonBlock(width: 118, height: 42, cornerRadius: 4)
                            }
                        } else {
                            ForEach(viewModel.brands, id: \.id) { brand in
                                Text(brand.name)
                                    .frame(width: 118, height: 42)
                                    .background(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(viewModel.selectedBrandIndex == brand.id ? SwiftUI.Color("AccentColor") : Color("BorderColor"), lineWidth: 1)
                                    )
                                    .id(brand.id)
                                    .onTapGesture {
                                        viewModel.selectBrand(index: brand.id)
                                        scrollToSelectedBrand(using: proxy, brandID: brand.id)
                                    }
                            }
                        }
                    }
                }
                .onAppear {
                    scrollToSelectedBrand(using: proxy, brandID: viewModel.selectedBrandIndex)
                }
                .onChange(of: viewModel.selectedBrandIndex) { _, brandID in
                    scrollToSelectedBrand(using: proxy, brandID: brandID)
                }
                .onChange(of: viewModel.brands) { _, _ in
                    scrollToSelectedBrand(using: proxy, brandID: viewModel.selectedBrandIndex)
                }
            }
            
            if !viewModel.searchText.isEmpty {
                HStack {
                    Text("Searching for:")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.gray)
                    
                    Text(viewModel.searchText)
                        .font(.system(size: 16, weight: .medium))
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(Color.lightRed)
                        .foregroundColor(Color.accent)
                        .cornerRadius(10)
                    
                    Spacer()
                }.padding(.top, 5)
            }
            
            VStack(spacing: 10) {
                if viewModel.isAnimating && viewModel.cars.isEmpty {
                    ForEach((0..<4).map { "cars-list-skeleton-\($0)" }, id: \.self) { _ in
                        CarSkeletonItemView()
                    }
                } else {
                    ForEach(0..<viewModel.cars.count, id: \.self) { index in
                        CarItemView(car: viewModel.cars[index]) {
                            viewModel.selectedCarID = viewModel.cars[index].id
                            viewModel.goToCarDetails()
                        }
                    }
                }
            }.padding(.top, 10)
        }
    }
    
    private func scrollToSelectedBrand(using proxy: ScrollViewProxy, brandID: Int?) {
        guard let brandID = brandID else { return }
        
        DispatchQueue.main.async {
            withAnimation {
                proxy.scrollTo(brandID, anchor: .center)
            }
        }
    }
}
