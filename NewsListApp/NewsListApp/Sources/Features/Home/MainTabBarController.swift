//
//  MainTabBarController.swift
//  NewsListApp
//
//  Created by Talish George on 29/11/21.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    // Mark: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureViewControllers()
    }
    
    func configureViewControllers() {
        
        let news = templateNavigationController(unSelectedImage: #imageLiteral(resourceName: "home_selected"), selectedImage: #imageLiteral(resourceName: "home_unselected-1"), rootViewController: NewsController())
        
        viewControllers = [news]
    }
    
    func templateNavigationController(unSelectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = unSelectedImage
        navController.tabBarItem.selectedImage = selectedImage
        navController.navigationBar.tintColor = .black
        return navController
    }
    
}
