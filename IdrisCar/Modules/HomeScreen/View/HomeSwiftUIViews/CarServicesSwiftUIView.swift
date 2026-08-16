//
//  CarServicesSwiftUIView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 02/03/2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct ServicesListView: View {
    let services: [Service]
    var onServiceSelected: ((Service) -> Void)?
    var onViewMoreTapped: (() -> Void)?
    
    var body: some View {
        VStack {
            HStack {
                Text("Feature Services")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color.black)
                Spacer()
                HStack {
                    Text("View More")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color.black)
                        .onTapGesture {
                            onViewMoreTapped?()
                        }
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
                    ForEach(services, id: \.id) { service in
                        ServiceItemView(
                            service: service,
                            onRequestTapped: {
                                onServiceSelected?(service)
                            }
                        )
                        .frame(width: itemWidth)
                    }
                }
                .padding(.trailing, 16) // ✅ only space AFTER last item
            }
            .frame(height: 200)
        }
    }
}


struct ServiceItemView: View {
    let service: Service
    var onRequestTapped: (() -> Void)?
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: service.image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
                .resizable()
                .indicator(.activity)
                .aspectRatio(contentMode: .fit)
                .frame(width: 136)
                .frame(maxHeight: .infinity)
                .cornerRadius(4)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(service.name)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                
                HStack {
                    HStack {
                        Image("ryal")
                        Text("760")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(SwiftUI.Color("AccentColor"))
                    }
                    
                    HStack {
                        Image("ryalGray")
                        Text("760")
                            .font(.system(size: 18, weight: .medium))
                            .strikethrough()
                            .foregroundColor(.gray)
                    }
                }
                
                Text(service.summary ?? "")
                    .font(.system(size: 14, weight: .regular))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.gray)
                
                HStack(spacing: 5) {
                    Button(action: {
                        onRequestTapped?() // Call the closure when the button is tapped
                    }) {
                        Text("Add Service")
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .background(SwiftUI.Color("AccentColor"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
//                    Button(action: {}) {
//                        Image(systemName: "heart")
//                            .foregroundColor(.gray)
//                            .padding()
//                            .frame(width: 36, height: 36)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 4)
//                                    .stroke(Color("BorderColor"), lineWidth: 1)
//                            )
//                    }
                }
            }
        }
        .padding(10)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color("BorderColor"), lineWidth: 1)
        )
        .frame(maxWidth: .infinity)
        .frame(height: 180)
    }
}
