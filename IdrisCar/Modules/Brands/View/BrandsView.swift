//
//  BrandsView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 25/03/2025.
//

import UIKit
import SwiftUI
import Combine
import SDWebImageSwiftUI

class BrandsView: UIViewController {
    
    var viewModel: BrandsViewModel?

    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AttachViews()
        BindViews()
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func AttachViews() {
        self.container.EmbedSwiftUIView(view: BrandsSwiftUIView(viewModel: viewModel!), parent: self)
    }
    
    func BindViews(){}
}


struct BrandsSwiftUIView: View {
    
    @ObservedObject var viewModel: BrandsViewModel
        
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 10) {
                if viewModel.isAnimating && viewModel.brands.isEmpty {
                    ForEach((0..<8).map { "brand-skeleton-\($0)" }, id: \.self) { _ in
                        BrandSkeletonItemView()
                            .frame(maxWidth: .infinity, minHeight: 130)
                    }
                } else {
                    ForEach(viewModel.brands, id: \.id) { brand in
                        VStack {
                            WebImage(url: URL(string: brand.image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 84, height: 84)
                            
                            Text(brand.name)
                                .lineLimit(2)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.black)
                                .padding(.horizontal, 5)
                        }
                        .frame(maxWidth: .infinity, minHeight: 130)
                        .padding(.horizontal, 5)
                        .background(Color("BackgroundGray"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color("BorderColor"), lineWidth: 1)
                        )
                        .onTapGesture {
                            viewModel.selectedBrandID = brand.id
                            viewModel.goToCars()
                        }
                    }
                }
            }
            .padding()
        }
    }
}
