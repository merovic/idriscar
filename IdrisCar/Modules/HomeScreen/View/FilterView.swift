//
//  FilterView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 31/03/2025.
//

import UIKit
import SwiftUI
import Combine
import CombineCocoa
import SDWebImageSwiftUI

class FilterView: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: FilterViewModel?
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AttachViews()
        BindViews()
    }
    
    func AttachViews() {
        guard let viewModel = viewModel else { return }
        self.container.EmbedSwiftUIView(view: FilterSwiftUIView(viewModel: viewModel), parent: self)
    }
    
    func BindViews(){
        guard let viewModel = viewModel else { return }
        
        viewModel.$backPressed.sink { [self] state in
            if state {
                self.navigationController?.popViewController(animated: true)
            }
        }.store(in: &viewModel.cancellables)
        
        backButton.tapPublisher
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &bindings)
        
        resetButton.tapPublisher
            .sink { _ in
                viewModel.resetAll()
            }
            .store(in: &bindings)
    }
}

struct FilterSwiftUIView: View {
    
    @ObservedObject var viewModel: FilterViewModel
        
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 35) {
                VStack(alignment: .leading, spacing: 20){
                    Text("Brands")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            if viewModel.isAnimating && viewModel.brands.isEmpty {
                                ForEach((0..<6).map { "filter-brand-skeleton-\($0)" }, id: \.self) { _ in
                                    BrandSkeletonItemView()
                                }
                            } else {
                                ForEach(viewModel.brands, id: \.id) { brand in
                                    VStack {
                                        WebImage(url: URL(string: brand.image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
                                          .resizable()
                                          .aspectRatio(contentMode: .fit)
                                          .frame(width: 84, height: 84)
                                        
                                        Text(brand.name)
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.black)
                                    }
                                    .frame(width: 105, height: 130)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(viewModel.selectedBrandID == brand.id ? Color("AccentColor") : Color("BorderColor"), lineWidth: 1)
                                    )
                                    .onTapGesture {
                                        viewModel.selectedBrandID = brand.id
                                    }
                                }
                            }
                        }
                    }
                }.padding(.top, 16)
                
                if !viewModel.allModels.isEmpty {
                    VStack(alignment: .leading, spacing: 20){
                        Text("Model")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(0..<viewModel.allModels.count, id: \.self) { index in
                                    Text(viewModel.allModels[index].name)
                                        .frame(height: 42)
                                        .background(Color.white)
                                        .padding(.horizontal)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 4)
                                                .stroke(viewModel.selectedModelID == viewModel.allModels[index].id ? Color("AccentColor") : Color("BorderColor"), lineWidth: 1)
                                        )
                                        .onTapGesture {
                                            viewModel.selectedModelID = viewModel.allModels[index].id
                                        }
                                }
                            }
                        }
                    }
                }
                
                if !viewModel.filteredVersions.isEmpty {
                    VStack(alignment: .leading, spacing: 20){
                        Text("Version")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(0..<viewModel.filteredVersions.count, id: \.self) { index in
                                    Text(viewModel.filteredVersions[index].name)
                                        .frame(height: 42)
                                        .background(Color.white)
                                        .padding(.horizontal)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 4)
                                                .stroke(viewModel.selectedVersionID == viewModel.filteredVersions[index].id ? Color("AccentColor") : Color("BorderColor"), lineWidth: 1)
                                        )
                                        .onTapGesture {
                                            viewModel.selectedVersionID = viewModel.filteredVersions[index].id
                                        }
                                }
                            }
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 20){
                    Text("Price Range")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                    
                    RangedSliderView(value: $viewModel.sliderPosition, bounds: 10000...50000).padding(.vertical, 16)
                    
                }
                
                
                VStack(alignment: .leading, spacing: 20){
                    Text("Car Type")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(0..<viewModel.carTypes.count, id: \.self) { index in
                                Text(viewModel.carTypes[index].name)
                                    .frame(height: 42)
                                    .background(Color.white)
                                    .padding(.horizontal)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(viewModel.selectedBodyTypeID == viewModel.carTypes[index].id ? Color("AccentColor") : Color("BorderColor"), lineWidth: 1)
                                    )
                                    .onTapGesture {
                                        viewModel.selectedBodyTypeID = viewModel.carTypes[index].id
                                    }
                            }
                        }
                    }
                }
                
                Button(action: {
                    viewModel.applyFilter()
                    viewModel.backPressed.toggle()
                }) {
                    Text("Apply")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(SwiftUI.Color("AccentColor"))
                        .cornerRadius(4)
                }
                .padding()
            }
        }
    }
}



struct RangedSliderView: View {
    let currentValue: Binding<ClosedRange<Float>>
    let sliderBounds: ClosedRange<Int>
    
    public init(value: Binding<ClosedRange<Float>>, bounds: ClosedRange<Int>) {
        self.currentValue = value
        self.sliderBounds = bounds
    }
    
    var body: some View {
        GeometryReader { geomentry in
            sliderView(sliderSize: geomentry.size)
        }
    }
    
        
    @ViewBuilder private func sliderView(sliderSize: CGSize) -> some View {
        let sliderViewYCenter = sliderSize.height / 2
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(SwiftUI.Color("TextGray"))
                .frame(height: 4)
            ZStack {
                let sliderBoundDifference = sliderBounds.count
                let stepWidthInPixel = CGFloat(sliderSize.width) / CGFloat(sliderBoundDifference)
                
                // Calculate Left Thumb initial position
                let leftThumbLocation: CGFloat = currentValue.wrappedValue.lowerBound == Float(sliderBounds.lowerBound)
                    ? 0
                    : CGFloat(currentValue.wrappedValue.lowerBound - Float(sliderBounds.lowerBound)) * stepWidthInPixel
                
                // Calculate right thumb initial position
                let rightThumbLocation = CGFloat(currentValue.wrappedValue.upperBound) * stepWidthInPixel
                
                // Path between both handles
                lineBetweenThumbs(from: .init(x: leftThumbLocation, y: sliderViewYCenter), to: .init(x: rightThumbLocation, y: sliderViewYCenter))
                
                // Left Thumb Handle
                let leftThumbPoint = CGPoint(x: leftThumbLocation, y: sliderViewYCenter)
                thumbView(position: leftThumbPoint, value: Float(currentValue.wrappedValue.lowerBound))
                    .highPriorityGesture(DragGesture().onChanged { dragValue in
                        
                        let dragLocation = dragValue.location
                        let xThumbOffset = min(max(0, dragLocation.x), sliderSize.width)
                        
                        let newValue = Float(sliderBounds.lowerBound) + Float(xThumbOffset / stepWidthInPixel)
                        
                        // Stop the range thumbs from colliding each other
                        if newValue < currentValue.wrappedValue.upperBound {
                            currentValue.wrappedValue = newValue...currentValue.wrappedValue.upperBound
                        }
                    })
                
                // Right Thumb Handle
                thumbView(position: CGPoint(x: rightThumbLocation, y: sliderViewYCenter), value: currentValue.wrappedValue.upperBound)
                    .highPriorityGesture(DragGesture().onChanged { dragValue in
                        let dragLocation = dragValue.location
                        let xThumbOffset = min(max(CGFloat(leftThumbLocation), dragLocation.x), sliderSize.width)
                        
                        var newValue = Float(xThumbOffset / stepWidthInPixel) // convert back the value bound
                        newValue = min(newValue, Float(sliderBounds.upperBound))
                        
                        // Stop the range thumbs from colliding each other
                        if newValue > currentValue.wrappedValue.lowerBound {
                            currentValue.wrappedValue = currentValue.wrappedValue.lowerBound...newValue
                        }
                    })
            }
        }
    }
    
    @ViewBuilder func lineBetweenThumbs(from: CGPoint, to: CGPoint) -> some View {
        Path { path in
            path.move(to: from)
            path.addLine(to: to)
        }.stroke(SwiftUI.Color("AccentColor"), lineWidth: 4)
    }
    
    @ViewBuilder func thumbView(position: CGPoint, value: Float) -> some View {
        ZStack {
            Circle()
                .frame(width: 24, height: 24)
                .foregroundColor(SwiftUI.Color("AccentColor"))
                .shadow(color: Color.black.opacity(0.16), radius: 8, x: 0, y: 2)
                .contentShape(Rectangle())
            
            HStack {
                Text(String(Int(value)))
                    .font(.system(size: 16, weight: .regular))
                
                Image("ryalDarkGray")
                    .resizable()
                    .frame(width: 14, height: 14)
            }.offset(y: 30)
        }
        .position(x: position.x, y: position.y)
    }
}
