//
//  ContactUsTextView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 18/06/2025.
//

import UIKit
import SwiftUI
import SDWebImageSwiftUI

class ContactUsTextView: UIViewController {
    
    var viewModel: ContactUsTextViewModel?
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AttachViews()
        BindViews()
    }
    
    func AttachViews() {
        self.container.EmbedSwiftUIView(view: ContactUsTextSwiftUIView(viewModel: viewModel!), parent: self)
    }
    
    func BindViews(){
        guard let viewModel = viewModel else { return }
        
        viewModel.$errorMessage
            .compactMap { $0.isEmpty ? nil : $0 }
            .sink { errorMessage in
                ToastManager.shared.showToast(
                    iconName: "erroricon",
                    titleText: "Edit Failed".localized,
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

struct ContactUsTextSwiftUIView: View {
    
    @ObservedObject var viewModel: ContactUsTextViewModel
    
    var body: some View {
        ScrollView{
            if viewModel.isAnimating && viewModel.websiteInfo == nil {
                VStack(spacing: 10) {
                    ForEach((0..<4).map { "contact-us-skeleton-\($0)" }, id: \.self) { _ in
                        ContactUsSkeletonItemView()
                    }
                }
            } else if viewModel.websiteInfo != nil{
                VStack(spacing: 10) {
                    ContactUsItemView(image: "working_hours", title: "Working Hours".localized, description: viewModel.websiteInfo!.workingHours.map { $0.hours }.joined(separator: ", "))
                    ContactUsItemView(image: "call_us", title: "Call us directly".localized, description: viewModel.websiteInfo!.mobileNumbers.map { $0.mobile }.joined(separator: ", "))
                    ContactUsItemView(image: "store_location", title: "Store location".localized, description: viewModel.websiteInfo!.address)
                    ContactUsItemView(image: "send_message", title: "Send a message".localized, description: viewModel.websiteInfo!.emails.map { $0.email }.joined(separator: ", "))
                }
            }
            
        }
    }
}

struct ContactUsSkeletonItemView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ShimmerSkeletonBlock(width: 58, height: 58, cornerRadius: 8)
            
            VStack(alignment: .leading, spacing: 8) {
                ShimmerSkeletonLine(width: 170, height: 20)
                ShimmerSkeletonLine(width: 240)
                ShimmerSkeletonLine(width: 180)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color("BorderColor"), lineWidth: 1)
        )
    }
}

struct ContactUsItemView: View {
    var image: String
    var title: String
    var description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 14){            
            Image(image)
                .resizable()
                .frame(width: 58, height: 58)
                .aspectRatio(contentMode: .fit)
            
            VStack(alignment: .leading, spacing: 3){
                HStack {
                    Text(title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                    Spacer()
                }
                
                Text(description)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.gray)
                
                Spacer()
            }
        }
        .padding()
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color("BorderColor"), lineWidth: 1)
        )
    }
}
