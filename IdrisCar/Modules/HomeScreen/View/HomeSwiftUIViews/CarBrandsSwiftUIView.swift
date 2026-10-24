//
//  CarBrandsSwiftUIView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 02/03/2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct CarBrandsView: View {
    let brands: [Brand]
    var isLoading: Bool = false
    var onBrandSelected: ((Brand) -> Void)?
    var onViewMoreTapped: (() -> Void)?
    
    var body: some View {
        VStack{
            HStack{
                Text("Car Brands")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color.black)
                Spacer()
                Button(action: {
                    onViewMoreTapped?()
                }) {
                    HStack {
                        Text("View More")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.black)
                        
                        Image(systemName: "chevron.forward")
                            .resizable()
                            .frame(width: 10, height: 18)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    if isLoading && brands.isEmpty {
                        ForEach((0..<6).map { "home-brand-skeleton-\($0)" }, id: \.self) { _ in
                            BrandSkeletonItemView()
                        }
                    } else {
                        ForEach(brands, id: \.id) { brand in
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
                                    .stroke(Color("BorderColor"), lineWidth: 1)
                            )
                            .onTapGesture {
                                onBrandSelected?(brand)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct BrandSkeletonItemView: View {
    var body: some View {
        VStack(spacing: 12) {
            ShimmerSkeletonBlock(width: 84, height: 84, cornerRadius: 8)
            ShimmerSkeletonLine(width: 64)
        }
        .frame(width: 105, height: 130)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color("BorderColor"), lineWidth: 1)
        )
    }
}
