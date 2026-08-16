//
//  ProfileView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 29/03/2025.
//

import UIKit
import SwiftUI

class ProfileView: UIViewController {
    
    var viewModel: ProfileViewModel?

    @IBOutlet weak var guestStackView: UIStackView!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var userStackView: UIStackView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userAddressLabel: UILabel!
    
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AttachViews()
        BindViews()
    }
    
    func AttachViews() {
        guard let viewModel = viewModel else { return }
        self.container.EmbedSwiftUIView(view: SettingsView(viewModel: viewModel), parent: self)
    }
    
    func BindViews() {
        guard let viewModel = viewModel else { return }
        
        viewModel.$userModel.sink { [self] user in
            if let user = user {
                headerHeight.constant = 150
                guestStackView.isHidden = true
                userStackView.isHidden = false
                
                userImage.image = UIImage.fromInitial(user.name, size: 20, backgroundColor: UIColor(named: "LightRed")!, textColor: UIColor(named: "AccentColor")!)
                
                userNameLabel.text = "\(user.name) \(user.lastName)"
                
                if let address = user.address {
                    userAddressLabel.text = address
                }else{
                    userAddressLabel.isHidden = true
                }
            } else{
                headerHeight.constant = 280
                guestStackView.isHidden = false
                userStackView.isHidden = true
            }
            
        }.store(in: &viewModel.cancellables)
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        viewModel?.signout()
    }
    
}

struct SettingsView: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if viewModel.userModel != nil {
                    // My Account Section
                    SectionView(title: "My Account".localized, items: [
                        ("Edit Profile".localized, "person.crop.circle", {
                            viewModel.goToEditProfile()
                        }),
                        ("Security login".localized, "lock", {
                            viewModel.goToSecurityLogin()
                        }),
                        ("Cars Requests".localized, "car", {
                            viewModel.goToCarsRequests()
                        }),
                        ("Services Requests".localized, "wrench", {
                            viewModel.goToServicesRequests()
                        }),
                        ("My Favorites".localized, "heart", {
                            viewModel.goToMyWishList()
                        })
                    ])
                }
                
                // Languages Section
                LanguageView(title: "Languages".localized, items: [
                    ("Arabic".localized, "🇸🇦", { changeLanguage(with: "ar") }, LanguageManager.shared.isArabic),
                    ("English".localized, "🇺🇸", { changeLanguage(with: "en") }, !LanguageManager.shared.isArabic)
                ])
                                
                // Help and Support Section
                SectionView(title: "Help and Support".localized, items: [
                    ("About us".localized, "info.circle", {
                        viewModel.goToAboutUs()
                    }),
                    ("Terms".localized, "doc.text", {
                        viewModel.goToTerms()
                    }),
                    ("FAQ".localized, "questionmark.circle", {
                        viewModel.goToFAQ()
                    }),
                    ("Contact Info".localized, "phone", {
                        viewModel.goToContactUsText()
                    }),
                    ("Contact Us".localized, "envelope", {
                        viewModel.goToContactUs()
                    })
                ])
                
                if viewModel.userModel != nil {
                    // Logout Button
                    Button(action: {
                        viewModel.signout()
                    }) {
                        HStack {
                            Image("sign-out")
                                .renderingMode(.template)
                                .foregroundColor(Color.accent)
                            Text("Sign out".localized)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color.accent)
                            Spacer()
                        }
                        .padding()
                        .background(Color.lightRed)
                    }
                }
                
                Spacer()
            }
        }
        .background(Color(.systemGray6))
    }
    
    private func changeLanguage(with code: String) {
        LanguageManager.shared.setLanguage(code)
        viewModel.changeLanguage()
    }
    
//    private func changeLanguage(with code: String) {
//        LanguageManager.shared.setLanguage(code)
//
//        if let sceneDelegate = UIApplication.shared.connectedScenes
//            .first?.delegate as? SceneDelegate {
//
//            sceneDelegate.restartApp()
//        }
//    }
}

struct SectionView: View {
    var title: String
    var items: [(String, String, () -> Void)]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .padding(20)

            ForEach(items.indices, id: \.self) { index in
                Button(action: items[index].2) {
                    HStack {
                        Image(systemName: items[index].1)
                            .foregroundColor(.gray)
                        Text(items[index].0)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                }
                if index < items.count - 1 { Divider() }
            }
        }
    }
}


struct LanguageView: View {
    var title: String
    var items: [(String, String, () -> Void, Bool)]
    
    @State private var showLanguageAlert = false
    @State private var selectedLanguageAction: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .padding(20)
            
            ForEach(items.indices, id: \.self) { index in
                Button {
                    selectedLanguageAction = items[index].2
                    showLanguageAlert = true
                } label: {
                    HStack {
                        Text(items[index].1) // flag
                        
                        Text(items[index].0)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        if items[index].3 {
                            Image(systemName: "checkmark")
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                }
                
                if index < items.count - 1 {
                    Divider()
                }
            }
        }
        .confirmationDialog(
            "Are you sure you want to change the language?".localized,
            isPresented: $showLanguageAlert,
            titleVisibility: .visible
        ) {
            Button("Yes".localized, role: .destructive) {
                selectedLanguageAction?()
            }
            
            Button("No".localized, role: .cancel) {}
        }
    }
}
