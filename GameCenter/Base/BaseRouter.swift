//
//  BaseRouter.swift
//  GameCenter
//
//  Created by Steven Lie on 18/08/21.
//

import UIKit

class TabbarController: UITabBarController {
    static var instance = TabbarController()

    private var previousSelectedTabIndex: Int = 0

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let viewController = self.viewControllers![previousSelectedTabIndex] as! UINavigationController
        viewController.popToRootViewController(animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        self.tabBar.layer.masksToBounds = true
        self.tabBar.isTranslucent = true
        self.tabBar.layer.cornerRadius = 20
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.tabBar.tintColor = .baseColor
        
        if #available(iOS 13.0, *) {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            tabBarAppearance.backgroundColor = .clear
            UITabBar.appearance().standardAppearance = tabBarAppearance

            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }

        UITabBar.appearance().unselectedItemTintColor = UIColor.gray

        let homeVC = StyledNavigationController(rootViewController: Injection.shared.makeHomeViewController())
        homeVC.tabBarItem =  UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "gamecontroller.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16)),
            selectedImage: UIImage(systemName: "gamecontroller.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16))
        )

        let searchVC = StyledNavigationController(rootViewController: Injection.shared.makeSearchViewController())
        searchVC.tabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16)),
            selectedImage: UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16))
        )

        let favoriteVC = StyledNavigationController(rootViewController: Injection.shared.makeFavoriteGamesViewController())
        favoriteVC.tabBarItem = UITabBarItem(
            title: "Favorite",
            image: UIImage(systemName: "bookmark.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16)),
            selectedImage: UIImage(systemName: "bookmark.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16))
        )

        let profileVC = StyledNavigationController(rootViewController: Injection.shared.makeProfileViewController())
        profileVC.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16)),
            selectedImage: UIImage(systemName: "person.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16))
        )

        self.viewControllers = [homeVC, searchVC, favoriteVC, profileVC]

    }
}

extension TabbarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.previousSelectedTabIndex = tabBarController.selectedIndex
    }
}

class StyledNavigationController: UINavigationController {
    var style: UIStatusBarStyle
    
    init(rootViewController: UIViewController, style: UIStatusBarStyle = .lightContent) {
        self.style = style
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return style
    }
}

extension UINavigationController {
    func setStatusBar(_ style: UIStatusBarStyle) {
        guard let self = self as? StyledNavigationController else { return }
        self.style = style
        self.setNeedsStatusBarAppearanceUpdate()
    }
}
