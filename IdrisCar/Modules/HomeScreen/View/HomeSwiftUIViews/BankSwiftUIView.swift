//
//  BankSwiftUIView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 02/03/2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct BanksListView: View {
    let banks: [HomeModel]
    
    var body: some View {
        VStack{
            HStack{
                Text("Banks")
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
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                let itemWidth = UIScreen.main.bounds.width - 32
                
                HStack(spacing: 16) {
                    ForEach(0..<banks.count, id: \.self) { index in
                        BankItemView(bank: banks[index])
                            .frame(width: itemWidth)
                    }
                }
                .padding(.trailing, 16) // ✅ only after items
            }
            .frame(height: 120)
        }
    }
}

struct BankItemView: View {
    let bank: HomeModel
    
    var body: some View {
        VStack {
            WebImage(url: URL(string: bank.image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
                .resizable()
                .indicator(.activity)
                .aspectRatio(contentMode: .fit)
                .frame(height: 80)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(Color(.systemGray6))
        .cornerRadius(6)
    }
}
