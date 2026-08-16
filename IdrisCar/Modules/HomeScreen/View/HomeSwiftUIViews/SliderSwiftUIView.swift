//
//  SliderSwiftUIView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 02/03/2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct CarouselItem: Identifiable {
    let id = UUID()
    let imagePath: String
}

struct ImageCarouselView: View {
    var data: [CarouselItem]
    
    @Binding var selectedSliderImage: CarouselItem?
    @State private var currentIndex: Int = 0
    
    var body: some View {
        VStack {
            TabView(selection: $currentIndex) {
                ForEach(0..<data.count, id: \.self) { index in
                    ZStack(alignment: .leading){
                        WebImage(url: URL(string: data[index].imagePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
                          .resizable()
                          .indicator(.activity)
                          .aspectRatio(contentMode: .fit)
                          .frame(width: UIScreen.main.bounds.width - 30)
                          .superCardGrayBackground()
                          .onTapGesture {
                              self.selectedSliderImage = data[index]
                          }
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            if data.count > 1 {
                PageControl(numberOfPages: data.count, currentPage: $currentIndex)
                    .padding(.top, 10)
            }
        }.frame(height: 200)
    }
}

struct PageControl: View {
    var numberOfPages: Int
    @Binding var currentPage: Int
    
    var body: some View {
        HStack {
            ForEach(0..<numberOfPages, id: \.self) { index in
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(index == currentPage ? Color.blue : .gray)
                    .padding(.horizontal, 4)
            }
        }
    }
}

//struct ImageCarouselView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageCarouselView(
//            data: [
//                CarouselItem(imagePath: "https://via.placeholder.com/600x400"),
//                CarouselItem(imagePath: "https://via.placeholder.com/600x400"),
//                CarouselItem(imagePath: "https://via.placeholder.com/600x400")
//            ],
//            selectedSliderImage: .constant(nil)
//        )
//    }
//}
//


struct SuperCardGrayBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.gray.opacity(0.2), radius: 5)
    }
}

extension View {
    func superCardGrayBackground() -> some View {
        modifier(SuperCardGrayBackground())
    }
}
