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
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: BrandsViewModel?
    
    private let loadingView = LoadingAnimation()

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
    
    func BindViews(){
        viewModel!.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &bindings)
    }
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
                ForEach(0..<viewModel.brands.count, id: \.self) { index in
                    VStack {
                        WebImage(url: URL(string: viewModel.brands[index].image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
                            .resizable()
                            .indicator(.activity)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 84, height: 84)
                        
                        Text(viewModel.brands[index].name)
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
                        viewModel.selectedBrandID = viewModel.brands[index].id
                        viewModel.goToCars()
                    }
                }
            }
            .padding()
        }
    }
}
