//
//  IdrisSelectionView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 27/05/2025.
//

import Foundation
import UIKit
import Combine
import SwiftUI

struct SelectionItem: Identifiable, Equatable {
    let id: Int
    let name: String
    let filterID: String?
    
    init(id: Int, name: String, filterID: String? = nil) {
        self.id = id
        self.name = name
        self.filterID = filterID
    }
}

enum SelectionKey: String {
    case brand
    case model
    case version
    case paymentMethod
    case none  // default fallback
}

protocol SelectionDelegate: AnyObject {
    func didSelectItem(_ item: SelectionItem, for key: SelectionKey)
}

class SelectionViewModel: ObservableObject {
    @Published var items: [SelectionItem] = []
    @Published var selectedItem: SelectionItem? = nil
    @Published var titleText: String = ""
    
    init(items: [SelectionItem], titleText: String) {
        self.items = items
        self.titleText = String(format: "Select %@".localized, titleText)
    }
}

class IdrisSelectionView: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: SelectionViewModel?
    weak var delegate: SelectionDelegate?
    var selectionKey: SelectionKey = .none
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViews()
        attachViews()
    }
    
    private func attachViews() {
        guard let viewModel = viewModel else { return }
        let swiftUIView = SelectionSwiftUIView(viewModel: viewModel)
        container.EmbedSwiftUIView(view: swiftUIView, parent: self)
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private func bindViews() {
        guard let viewModel = viewModel else { return }
        viewModel.$titleText
            .receive(on: DispatchQueue.main)
            .assign(to: \.text!, on: titleLabel)
            .store(in: &bindings)
        
        viewModel.$items
            .sink { [weak self] items in
                guard let self = self else { return }
                let newHeight = CGFloat(items.count * 64) + 65
                viewHeight.constant = min(newHeight, 650)
            }
            .store(in: &bindings)
        
        viewModel.$selectedItem
            .sink { [weak self] item in
                guard let self = self, let selectedItem = item else { return }
                self.delegate?.didSelectItem(selectedItem, for: self.selectionKey)
                self.dismiss(animated: true)
            }
            .store(in: &bindings)
    }
}

struct SelectionSwiftUIView: View {
    @ObservedObject var viewModel: SelectionViewModel
    
    var body: some View {
        ZStack {
            if viewModel.items.isEmpty {
                VStack {
                    Text("No items available")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Spacer()
                }
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(viewModel.items.indices, id: \.self) { index in
                            let item = viewModel.items[index]
                            
                            Button(action: {
                                viewModel.selectedItem = item
                            }) {
                                HStack {
                                    Text(item.name)
                                        .foregroundColor(.black)
                                        .font(.system(size: 16, weight: .medium))
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                        .flipsForRightToLeftLayoutDirection(true)
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal)
                                .background(Color.white)
                            }.frame(height: 60)
                            
                            if index != viewModel.items.indices.last {
                                Divider()
                            }
                        }
                    }
                    .background(Color.white)
                }
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}
