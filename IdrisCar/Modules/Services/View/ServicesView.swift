//
//  ServicesView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 27/03/2025.
//

import UIKit
import SwiftUI
import Combine

class ServicesView: UIViewController {
    
    var viewModel: ServicesViewModel?
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var searchBar: UITextField!
    
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AttachViews()
        BindViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let viewModel = viewModel else { return }
        viewModel.getServices()
    }
    
    func AttachViews() {
        self.container.EmbedSwiftUIView(view: ServicesSwiftUIView(viewModel: self.viewModel!), parent: self)
    }
    
    func BindViews(){
        guard let viewModel = viewModel else { return }
        
        viewModel.$isBackButtonVisible
            .receive(on: DispatchQueue.main)
            .map { !($0 ?? false) }
            .assign(to: \.isHidden, on: backButton)
            .store(in: &viewModel.cancellables)
    }
}

struct ServicesSwiftUIView: View {
    
    @ObservedObject var viewModel: ServicesViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                if viewModel.isAnimating && viewModel.services.isEmpty {
                    ForEach((0..<5).map { "services-list-skeleton-\($0)" }, id: \.self) { _ in
                        ServiceSkeletonItemView()
                    }
                } else {
                    ForEach(0..<viewModel.services.count, id: \.self) { index in
                        ServiceItemView(service: viewModel.services[index]) {
                            viewModel.selectedServiceID = viewModel.services[index].id
                            viewModel.showServiceDetails()
                        }
                    }
                }
            }
        }
    }
}
