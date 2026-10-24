//
//  ServicesReqestsView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 04/06/2025.
//

import UIKit
import SwiftUI
import SDWebImageSwiftUI

class ServicesReqestsView: UIViewController {
    
    var viewModel: ServicesReqestsViewModel?
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AttachViews()
        BindViews()
    }
    
    func AttachViews() {
        guard let viewModel = viewModel else { return }
        self.container.EmbedSwiftUIView(view: ServicesReqestsSwiftUIView(viewModel: viewModel), parent: self)
    }
    
    func BindViews(){
        guard let viewModel = viewModel else { return }
        
        viewModel.$errorMessage
            .compactMap { $0.isEmpty ? nil : $0 }
            .sink { errorMessage in
                ToastManager.shared.showToast(
                    iconName: "erroricon",
                    titleText: "Car Requests".localized,
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

struct ServicesReqestsSwiftUIView: View {
    @ObservedObject var viewModel: ServicesReqestsViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false){
            if viewModel.isAnimating && viewModel.servicesRequests.isEmpty {
                VStack {
                    ForEach((0..<3).map { "service-request-skeleton-\($0)" }, id: \.self) { _ in
                        RequestSkeletonItemView()
                    }
                }
            } else if viewModel.servicesRequests.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "wrench.and.screwdriver")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    
                    Text("No Service Requests")
                        .font(.headline)
                    
                    Text("You don't have any service requests yet.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, minHeight: 300)
            } else {
                VStack{
                    ForEach(viewModel.servicesRequests, id: \.id) { request in
                        ServiceRequestsItem(request: request, onRequestTapped: {
                            
                        })
                    }
                }
            }
        }
    }
}

struct ServiceRequestsItem: View {
    var request: MyService
    var onRequestTapped: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .top) {
                WebImage(url: URL(string: request.service.image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""),
                         context: [.imageTransformer: WhiteBackgroundRemover()])
                    .resizable()
                    .indicator(.activity)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 370, height: 222)
                
            }

            Text(request.service.name)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
                .padding(.horizontal)

            VStack(spacing: 12) {
                HStack(alignment: .center) {
                    Text("Status:")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(SwiftUI.Color.gray)
                    Spacer()
                    Text(request.actionStatus ?? "Pending".localized)
                        .font(.system(size: 12, weight: .regular))
                        .padding(.vertical, 2)
                        .padding(.horizontal, 8)
                        .background(Color.lightRed)
                        .foregroundColor(Color.accent)
                        .cornerRadius(4)
                }
                
                HStack(alignment: .center) {
                    Text("Price:")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(SwiftUI.Color.gray)
                    Spacer()
                    HStack {
                        Image("ryal")
                        Text(String(request.price ?? 0))
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(SwiftUI.Color("AccentColor"))
                    }
                }
                
                Button(action: {
                    onRequestTapped?()
                }) {
                    Text("View")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(SwiftUI.Color("AccentColor"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }.padding()
        }
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color("BorderColor"), lineWidth: 1)
        )
        .padding()
    }
}
