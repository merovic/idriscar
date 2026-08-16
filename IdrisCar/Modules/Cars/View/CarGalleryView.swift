//
//  CarGalleryView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 22/06/2025.
//

import UIKit
import SwiftUI
import SDWebImageSwiftUI

class CarGalleryView: UIViewController {
    
    var viewModel: CarGalleryViewModel?
    
    private let loadingView = LoadingAnimation()

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AttachViews()
        BindViews()
    }
    
    func AttachViews() {
        self.container.EmbedSwiftUIView(view: CarGallerySwiftUIView(viewModel: viewModel!), parent: self)
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
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &viewModel.cancellables)
    }
}

struct CarGallerySwiftUIView: View {
    
    @ObservedObject var viewModel: CarGalleryViewModel
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(0..<viewModel.albums.count, id: \.self) { index in
                            AlbumItemView(album: viewModel.albums[index])
                                .onTapGesture {
                                    viewModel.selectedAlbum = viewModel.albums[index]
                                }
                        }
                    }
                }
                
                Divider().padding()
                
                if let album = viewModel.selectedAlbum {
                    SubAlbumsView(album: album) { image in
                        withAnimation(.easeInOut(duration: 0.25)) {
                            viewModel.selectedImage = image
                        }
                    }
                }
                
                Spacer()
            }

            // 🔥 Preview Overlay
            if let selectedImage = viewModel.selectedImage {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                    .onTapGesture {
                        viewModel.selectedImage = nil
                    }

                VStack {
                    WebImage(url: URL(string: selectedImage.image))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .padding()

                    Button("Close") {
                        viewModel.selectedImage = nil
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                }
            }
        }
    }
}

struct SubAlbumsView: View {
    var album: Album
    var onImageTap: (ImageItem) -> Void
    
    let columns = [
        GridItem(.fixed(186), spacing: 10),
        GridItem(.fixed(186), spacing: 10)
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(album.name)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            Text(album.description ?? "")
                .font(.system(size: 12))
                .foregroundColor(.gray)
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(0..<album.images.count, id: \.self) { index in
                        SubAlbumItemView(album: album.images[index])
                            .onTapGesture {
                                onImageTap(album.images[index])
                            }
                    }
                }
            }
        }
    }
}

struct AlbumItemView: View {
    var album: Album
    
    var body: some View {
        VStack(alignment: .center) {
            WebImage(url: URL(string: album.images.first?.image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
                .resizable()
                .indicator(.activity)
                .aspectRatio(contentMode: .fill)
                .frame(width: 170, height: 120)
                .cornerRadius(4)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(album.name)
                    .lineLimit(.none)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                Text(album.description ?? "")
                    .lineLimit(.none)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
        }
        .padding(10)
        .background(Color("BackgroundGray"))
        .cornerRadius(4)
        .frame(width: 186, height: 186)
    }
}


struct SubAlbumItemView: View {
    var album: ImageItem
    
    var body: some View {
        VStack(alignment: .center) {
            WebImage(url: URL(string: album.image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
                .resizable()
                .indicator(.activity)
                .aspectRatio(contentMode: .fill)
                .frame(width: 170, height: 120)
                .cornerRadius(4)
                .clipped()

            VStack(alignment: .leading, spacing: 5) {
                Text(album.name ?? "")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Text(album.description ?? "")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(10)
        .background(Color("BackgroundGray"))
        .cornerRadius(4)
    }
}
