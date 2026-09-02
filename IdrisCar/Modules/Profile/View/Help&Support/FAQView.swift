//
//  FAQView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 18/06/2025.
//

import UIKit
import SwiftUI

class FAQView: UIViewController {
    
    var viewModel: FAQViewModel?
    
    private let loadingView = LoadingAnimation()

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AttachViews()
        BindViews()
    }
    
    func AttachViews() {
        self.container.EmbedSwiftUIView(view: FAQSwiftUIView(viewModel: viewModel!), parent: self)
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
                    titleText: "FAQ".localized,
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

struct FAQSwiftUIView: View {
    
    @ObservedObject var viewModel: FAQViewModel
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 10) {
                Text(viewModel.faqList?.name ?? "")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                
                Text(viewModel.faqList?.description ?? "")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
            }
            
            if let questions = viewModel.faqList?.questionsAnswers {
                VStack(spacing: 10) {
                    ForEach(0..<questions.count, id: \.self) { index in
                        FAQItemView(item: questions[index])
                    }
                }
            }
            
        }
    }
}

struct FAQItemView: View {
    var item: QuestionsAnswer
    
    @State var isVisible: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            HStack {
                Text(item.question)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: {
                    isVisible.toggle()
                }) {
                    Image(isVisible ? "minus" : "plus")
                }
                
            }
            
            if isVisible {
                Text(item.answer)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}
