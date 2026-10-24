//
//  CarOfferSwiftUIView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 02/03/2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct CarsListView: View {
    let cars: [Car]
    var isLoading: Bool = false
    var onCarSelected: ((Car) -> Void)?
    var onViewMoreTapped: (() -> Void)?
    
    var body: some View {
        VStack{
            HStack{
                Text("Car Feature")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color.black)
                Spacer()
                HStack{
                    Text("View More")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color.black)
                        .onTapGesture {
                        }
                    Image(systemName: "chevron.forward")
                        .resizable()
                        .frame(width: 10, height: 18)
                        .foregroundColor(.gray)
                }.onTapGesture {
                    onViewMoreTapped?()
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                let itemWidth = UIScreen.main.bounds.width - 32 // 16 padding each side
                
                HStack(spacing: 16) {
                    if isLoading && cars.isEmpty {
                        ForEach((0..<3).map { "home-car-skeleton-\($0)" }, id: \.self) { _ in
                            CarSkeletonItemView()
                                .frame(width: itemWidth)
                        }
                    } else {
                        ForEach(0..<cars.count, id: \.self) { index in
                            CarItemView(
                                car: cars[index],
                                onCarSelected: {
                                    onCarSelected?(cars[index])
                                }
                            )
                            .frame(width: itemWidth)
                        }
                    }
                }
                .padding(.leading, 0)
                .padding(.trailing, 16)
            }
            .frame(height: 420)
        }
    }
}

struct CarSkeletonItemView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ShimmerSkeletonBlock(height: 222, cornerRadius: 6)
                .frame(maxWidth: .infinity)
            ShimmerSkeletonBlock(width: 80, height: 28, cornerRadius: 2)
            ShimmerSkeletonLine(width: 180, height: 20)
            ShimmerSkeletonLine(width: 120, height: 18)
            
            HStack {
                ShimmerSkeletonBlock(height: 48, cornerRadius: 8)
                    .frame(maxWidth: .infinity)
                ShimmerSkeletonBlock(width: 48, height: 48, cornerRadius: 4)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color("BorderColor"), lineWidth: 1)
        )
    }
}

struct CarItemView: View {
    let car: Car
    var onCarSelected: (() -> Void)?
    var onFavoriteClicked: (() -> Void)?
    
    @EnvironmentObject var favoritesManager: CarFavoritesManager

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .top) {
                WebImage(url: URL(string: car.image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
                .resizable()
                .indicator(.activity)
                .aspectRatio(contentMode: .fit)
                .frame(height: 222)
                .frame(maxWidth: .infinity)
                
                HStack {
                    if car.stickerStatus != .unknown {
                        Text(car.statusSticker.uppercased())
                            .font(.system(size: 12, weight: .medium))
                            .padding(.vertical, 6)
                            .padding(.horizontal, 20)
                            .background(car.stickerStatus.color)
                            .foregroundColor(.white)
                            .cornerRadius(40)
                    }
                    
                    Spacer()
                    
                    Text("\("From".localized) \(car.year.map(String.init) ?? "0")")
                        .font(.system(size: 14, weight: .medium))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 16)
                        .background(Color("BackgroundLightGray"))
                        .foregroundColor(.black)
                        .cornerRadius(40)
                }
            }
            
            Text(car.brand)
                .font(.system(size: 14, weight: .medium))
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(Color("BackgroundGray"))
                .foregroundColor(.black)
                .cornerRadius(2)
            
            Text(car.name)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            
            HStack {
                if let price = car.price {
                    HStack {
                        Image("ryal")
                        Text(String(price))
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(SwiftUI.Color("AccentColor"))
                    }
                }
                
                if let oldPrice = car.oldPrice {
                    HStack {
                        Image("ryalGray")
                        Text(oldPrice)
                            .font(.system(size: 16, weight: .medium))
                            .strikethrough()
                            .foregroundColor(.gray)
                    }
                }
            }
            
            HStack {
                Button(action: {
                    onCarSelected?()
                }) {
                    Text("Request a Car")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(SwiftUI.Color("AccentColor"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    onFavoriteClicked?()
                    favoritesManager.toggleFavorite(car)
                }) {
                    Image(systemName: favoritesManager.isFavorite(car) ? "heart.fill" : "heart")
                        .foregroundColor(favoritesManager.isFavorite(car) ? .accent : .gray)
                        .padding()
                        .frame(width: 48, height: 48)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color("BorderColor"), lineWidth: 1)
                        )
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color("BorderColor"), lineWidth: 1)
        )
    }
}
