//
//  ComparisonView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 29/05/2025.
//

import UIKit
import SwiftUI
import SDWebImageSwiftUI

class ComparisonView: UIViewController {
    
    var viewModel: ComparisonViewModel?

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var requestButton1: UIButton!
    @IBOutlet weak var requestButton2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AttachViews()
        BindViews()
    }
    
    func AttachViews() {
        self.container.EmbedSwiftUIView(view: ComparisonSwiftUIView(viewModel: viewModel!), parent: self)
    }
    
    func BindViews(){
        guard let viewModel = viewModel else { return }
        
        backButton.tapPublisher
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.$carsToCompare
            .sink { [weak requestButton2] cars in
                requestButton2?.isHidden = cars.count <= 1
                if cars.isEmpty {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.$addCarPressed
            .dropFirst()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                let carSelectionView = CarSelectionView()
                carSelectionView.viewModel = CarSelectionViewModel()
                carSelectionView.delegate = self
                self.navigationController?.pushViewController(carSelectionView, animated: true)
            }
            .store(in: &viewModel.cancellables)
        
        requestButton1.tapPublisher
            .sink { _ in
                if let car1 = viewModel.carsToCompare[safe: 0] {
                    viewModel.requestCar(car: car1)
                }
            }
            .store(in: &viewModel.cancellables)
        
        requestButton2.tapPublisher
            .sink { _ in
                if let car2 = viewModel.carsToCompare[safe: 1] {
                    viewModel.requestCar(car: car2)
                }
            }
            .store(in: &viewModel.cancellables)
    }
}

extension ComparisonView: CarSelectionViewDelegate {
    func didSelectCar(car: Car) {
        guard let viewModel = viewModel else { return }
        CarsDataService.shared.saveCarToCompare(car)
        viewModel.createComparison()
    }
}

struct ComparisonSwiftUIView: View {
    @ObservedObject var viewModel: ComparisonViewModel
    var body: some View {
        VStack{
            CarComparisonView(viewModel: viewModel)
        }
    }
}

struct ComparisonCarItemView: View {
    let car: Car
    let isButtonOnLeft: Bool
    var onDeleteCarTapped: (() -> Void)?

    var body: some View {
        ZStack(alignment: isButtonOnLeft ? .topTrailing : .topLeading) {
            VStack(alignment: .leading, spacing: 12) {
                ZStack(alignment: .top) {
                    WebImage(url: URL(string: car.image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
                        .resizable()
                        .indicator(.activity)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 165, height: 80)
                }

                Text(car.brand)
                    .font(.system(size: 14, weight: .regular))
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(Color("BackgroundGray"))
                    .foregroundColor(.black)
                    .cornerRadius(2)

                Text(car.name)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)

                HStack {
                    Image("ryal")
                    Text(String(car.price ?? 0))
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(SwiftUI.Color("AccentColor"))
                }

            }
            .frame(height: 192)
            .padding(6)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color("BorderColor"), lineWidth: 1)
            )
            
            Image("redClose")
                .resizable()
                .frame(width: 38, height: 38)
                .offset(x: isButtonOnLeft ? 10 : -10, y: -10)
                .onTapGesture {
                    onDeleteCarTapped?()
                }
        }
    }
}

struct ComparisonEmptyCarItemView: View {
    var onCarAddedTapped: (() -> Void)?
    var body: some View {
        ZStack {
            Color("BackgroundLightGray")

            Button(action: {
                onCarAddedTapped?()
            }) {
                Image("grayPlus")
                    .resizable()
                    .frame(width: 38, height: 38)
            }
        }
        .frame(width: 165, height: 192)
        .padding(6)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color("BorderColor"), lineWidth: 1)
        )
    }
}


struct CarComparisonView: View {
    @ObservedObject var viewModel: ComparisonViewModel
    @State private var expandedItems: Set<String> = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let comparison = viewModel.comparison {
                    HStack {
                        ComparisonCarItemView(car: comparison.car1, isButtonOnLeft: false, onDeleteCarTapped: {
                            viewModel.deleteCar(carID: comparison.car1.id)
                        }).frame(maxWidth: .infinity, alignment: .center)
                        
                        if let car2 = comparison.car2 {
                            ComparisonCarItemView(car: car2, isButtonOnLeft: true, onDeleteCarTapped: {
                                viewModel.deleteCar(carID: car2.id)
                            }).frame(maxWidth: .infinity, alignment: .center)
                        }else{
                            ComparisonEmptyCarItemView(onCarAddedTapped: {
                                viewModel.addCarPressed.toggle()
                            }).frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .padding(.horizontal)
                    
                    ForEach(comparison.featureGroups, id: \.groupName) { group in
                        featureGroupView(group: group)
                    }
                }
            }
            .padding(.vertical)
        }
    }
    
    private func featureGroupView(group: FeatureComparison) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: { toggleGroup(group.groupName) }) {
                HStack {
                    Text(group.groupName)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                    Spacer()
                    Image(systemName: expandedItems.contains(group.groupName) ? "chevron.down" : "chevron.right")
                        .foregroundColor(.white)
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                }
                .padding(.vertical, 8)
                .background(Color("AccentBlueColor"))
            }
            
            if expandedItems.contains(group.groupName) {
                ForEach(Array(group.features.enumerated()), id: \.element.name) { index, feature in
                    HStack {
                        Text(feature.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.black)
                        Text((feature.car1Value?.isEmpty ?? true) ? "-" : feature.car1Value!)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.gray)
                        Text((feature.car2Value?.isEmpty ?? true) ? "-" : feature.car2Value!)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.gray)
                    }
                    .font(.system(size: 14))
                    .frame(minHeight: 42)
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                    .background(Color("LightRed").opacity(0.3))
                    .padding(.vertical, 6)
                    //.background(index.isMultiple(of: 2) ? Color("LightRed").opacity(0.15) : Color.clear)
                }
            }
            Divider()
                .padding(.top, 8)
        }.padding(.horizontal)
    }
    
    private func toggleGroup(_ groupName: String) {
        if expandedItems.contains(groupName) {
            expandedItems.remove(groupName)
        } else {
            expandedItems.insert(groupName)
        }
    }
}
