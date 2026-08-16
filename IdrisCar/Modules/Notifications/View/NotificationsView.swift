//
//  NotificationsView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 31/03/2025.
//

import UIKit
import SwiftUI
import Combine

class NotificationsView: UIViewController {
        
    var viewModel: NotificationsViewModel?
    
    private let loadingView = LoadingAnimation()

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var searchBar: UITextField!
    
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AttachViews()
        BindViews()
    }
    
    func AttachViews() {
        self.container.EmbedSwiftUIView(view: NotificationsSwiftUIView(viewModel: viewModel!), parent: self)
    }
    
    func BindViews(){
        guard let viewModel = viewModel else { return }
        
        viewModel.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &viewModel.cancellables)
        
        backButton.tapPublisher
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &viewModel.cancellables)
    }
}

struct NotificationsSwiftUIView: View {
    
    @ObservedObject var viewModel: NotificationsViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                ForEach(0..<viewModel.notifications.count, id: \.self) { index in
                    NotificationItem(notification: viewModel.notifications[index])
                }
            }
        }
    }
}

struct NotificationItem: View {
    let notification: NotificationModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "bell")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.gray)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
            
            VStack(alignment: .leading, spacing: 5) {
                Text(notification.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(notification.createdAt)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
