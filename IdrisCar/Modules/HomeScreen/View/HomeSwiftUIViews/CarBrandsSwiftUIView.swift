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
                    ForEach(0..<brands.count, id: \.self) { index in
                        VStack {                            
                            WebImage(url: URL(string: brands[index].image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
                              .resizable()
                              .indicator(.activity)
                              .aspectRatio(contentMode: .fit)
                              .frame(width: 84, height: 84)
                            
                            Text(brands[index].name)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.black)
                        }
                        .frame(width: 105, height: 130)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color("BorderColor"), lineWidth: 1)
                        )
                        .onTapGesture {
                            onBrandSelected?(brands[index])
                        }
                    }
                }
            }
        }
    }
}
