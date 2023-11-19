//
//  TabbarController.swift
//  PapcornsCase
//
//  Created by Ömer Firat on 17.11.2023.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let firstViewController = ViewController()
        let firstNavController = UINavigationController(rootViewController: firstViewController)
        firstNavController.tabBarItem = UITabBarItem(title: "Discover", image: UIImage(named: "unselectedDiscovery"), selectedImage: nil)

        let secondViewController = FavoritesViewController()
        let secondNavController = UINavigationController(rootViewController: secondViewController)
        secondNavController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(named: "unselectedHeart"), selectedImage: nil)

        self.viewControllers = [firstNavController, secondNavController]

        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .black
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.lightGray]

        tabBar.standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = tabBarAppearance
        }

        self.tabBar.tintColor = .white
        self.tabBar.unselectedItemTintColor = .lightGray
    }
}
