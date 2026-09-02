//
//  AboutUsView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 18/06/2025.
//

import UIKit
import SwiftUI
import SDWebImageSwiftUI

class AboutUsView: UIViewController {
    
    var viewModel: AboutUsViewModel?
    
    private let loadingView = LoadingAnimation()

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AttachViews()
        BindViews()
    }
    
    func AttachViews() {
        self.container.EmbedSwiftUIView(view: AboutUsSwiftUIView(viewModel: viewModel!), parent: self)
    }
    
    func BindViews(){
        guard let viewModel = viewModel else { return }
        
        viewModel.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &viewModel.cancellables)
        
        viewModel.$errorMessage
            .compactMap { $0.isEmpty ? nil : $0 }
            .sink { errorMessage in
                ToastManager.shared.showToast(
                    iconName: "erroricon",
                    titleText: "About".localized,
                    subtitleText: errorMessage,
                    hapticFeedback: .notification(type: .error)
                )
            }
            .store(in: &viewModel.cancellables)
        
        backButton.tapPublisher
            .sink {
                viewModel.popView()
            }
            .store(in: &viewModel.cancellables)
    }

}

struct AboutUsSwiftUIView: View {
    
    @ObservedObject var viewModel: AboutUsViewModel
    
    var body: some View {
        ScrollView{
            VStack(spacing: 10) {
                ForEach(viewModel.aboutUsList, id: \.id) { item in
                    AboutUsItemView(item: item)
                }
            }
        }
    }
}

struct AboutUsItemView: View {
    let item: AboutUsAPIResponse
    private let descriptionText: String
    
    init(item: AboutUsAPIResponse) {
        self.item = item
        self.descriptionText = item.description?.htmlToString ?? ""
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16){
            WebImage(url: URL(string: item.image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
                .resizable()
                .indicator(.activity)
                .aspectRatio(contentMode: .fit)
                .frame(width: 64, height: 64)
            
            Text(item.name)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            
            Text(descriptionText)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color("BorderColor"), lineWidth: 1)
        )
    }
}
