//
//  HomeTabBarViewViewController.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 04/03/2025.
//

import UIKit

class HomeTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var middleButton: UIButton?
    
    weak var coordinator: MainCoordinator?
    
    init(tabs: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = tabs
        setupTabBarItems()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTabBarItems() {
        let icons = ["tabHome", "tabCar", "", "tabOil", "tabUser"]
        let titles = [
            "Home".localized,
            "Browse".localized,
            "",
            "Services".localized,
            "Account".localized]
        
        guard let viewControllers = viewControllers else { return }
        
        for (index, vc) in viewControllers.enumerated() {
            let tabBarItem = UITabBarItem(title: titles[index], image: UIImage(named: icons[index]), selectedImage: UIImage(named: icons[index]))
            vc.tabBarItem = tabBarItem
        }
        
        self.selectedIndex = 0
        self.tabBar.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupMiddleButton()
    }

    private func setupMiddleButton() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "centerButtonBigRed"), for: .normal)
        button.frame.size = CGSize(width: 64, height: 64)
        button.center = CGPoint(x: tabBar.bounds.midX, y: 0)
        button.addTarget(self, action: #selector(middleButtonTapped), for: .touchUpInside)
        tabBar.addSubview(button)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        middleButton?.center.y = tabBar.bounds.height - 45 - tabBar.safeAreaInsets.bottom
    }
    
    @objc func middleButtonTapped() {
        self.selectedIndex = 2
    }
}
