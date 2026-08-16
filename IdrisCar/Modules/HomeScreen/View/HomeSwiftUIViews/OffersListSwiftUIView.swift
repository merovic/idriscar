//
//  OffersListSwiftUIView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 02/03/2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct OffersListSwiftUIView: View {
    let offers: [Offer]
    var onOfferSelected: ((Offer) -> Void)?
    var onViewMoreTapped: (() -> Void)?
    
    var body: some View {
        VStack {
            HStack {
                Text("Offers")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color.black)
                Spacer()
                HStack {
                    Text("View More")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color.black)
                    Image(systemName: "chevron.forward")
                        .resizable()
                        .frame(width: 10, height: 18)
                        .foregroundColor(.gray)
                }
                .onTapGesture {
                    onViewMoreTapped?()
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                let itemWidth = UIScreen.main.bounds.width - 32
                
                HStack(spacing: 16) {
                    ForEach(offers, id: \.id) { offer in
                        OfferItemView(
                            offer: offer,
                            onGetOfferTapped: {
                                onOfferSelected?(offer)
                            }
                        )
                        .frame(width: itemWidth)
                    }
                }
                .padding(.trailing, 16) // ✅ only spacing AFTER items
            }
            .frame(height: 300)
        }
    }
}


struct OfferItemView: View {
    let offer: Offer
    var onGetOfferTapped: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            WebImage(url: URL(string: offer.image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
                .resizable()
                .indicator(.activity)
                .aspectRatio(contentMode: .fit)
                .frame(height: 210)
                .frame(maxWidth: .infinity)
            
            Text(offer.name)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            
            Text(offer.slug)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.gray)
            
            Button(action: {
                onGetOfferTapped?()
            }) {
                Text("Get Offer")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(SwiftUI.Color("AccentColor"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding(10)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color("BorderColor"), lineWidth: 1)
        )
        .frame(maxWidth: .infinity)
    }
}
