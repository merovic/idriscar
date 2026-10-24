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
    var isLoading: Bool = false
    
    @Binding var selectedSliderImage: CarouselItem?
    @State private var currentIndex: Int = 0
    private let skeletonItems = (0..<3).map { "ad-slider-skeleton-\($0)" }
    
    var body: some View {
        VStack {
            if isLoading && data.isEmpty {
                TabView(selection: $currentIndex) {
                    ForEach(Array(skeletonItems.enumerated()), id: \.element) { index, _ in
                        AdSliderSkeletonItemView()
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            } else {
                TabView(selection: $currentIndex) {
                    ForEach(Array(data.enumerated()), id: \.element.id) { index, item in
                        ZStack(alignment: .leading){
                            WebImage(url: URL(string: item.imagePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
                              .resizable()
                              .indicator(.activity)
                              .aspectRatio(contentMode: .fit)
                              .frame(width: UIScreen.main.bounds.width - 30)
                              .superCardGrayBackground()
                              .onTapGesture {
                                  self.selectedSliderImage = item
                              }
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            
            if isLoading && data.isEmpty {
                SkeletonPageControl(numberOfPages: skeletonItems.count)
                    .padding(.top, 10)
            } else if data.count > 1 {
                PageControl(numberOfPages: data.count, currentPage: $currentIndex)
                    .padding(.top, 10)
            }
        }.frame(height: 200)
    }
}

struct AdSliderSkeletonItemView: View {
    var body: some View {
        ShimmerSkeletonBlock(
            width: UIScreen.main.bounds.width - 30,
            height: 170,
            cornerRadius: 15
        )
        .superCardGrayBackground()
    }
}

struct SkeletonPageControl: View {
    var numberOfPages: Int
    
    var body: some View {
        HStack {
            ForEach((0..<numberOfPages).map { "ad-slider-dot-skeleton-\($0)" }, id: \.self) { _ in
                ShimmerSkeletonBlock(width: 8, height: 8, cornerRadius: 4)
                    .padding(.horizontal, 4)
            }
        }
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
