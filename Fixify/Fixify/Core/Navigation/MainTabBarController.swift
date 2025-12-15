//
//  MainTabBarController.swift
//  Fixify
//
//  Created by BP-36-213-03 on 15/12/2025.
//


import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    private func setupTabs() {

        // HOME (placeholder for now)
        let homeVC = UINavigationController(
            rootViewController: PlaceholderViewController(titleText: "Home")
        )
        homeVC.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )

        // REQUESTS (YOUR EXISTING SCREEN)
        let requestsVC = UINavigationController(
            rootViewController: AllRequestsViewController()
        )
        requestsVC.tabBarItem = UITabBarItem(
            title: "Requests",
            image: UIImage(systemName: "doc.text"),
            selectedImage: UIImage(systemName: "doc.text.fill")
        )

        // NOTIFICATIONS (placeholder)
        let notificationsVC = UINavigationController(
            rootViewController: PlaceholderViewController(titleText: "Notifications")
        )
        notificationsVC.tabBarItem = UITabBarItem(
            title: "Notifications",
            image: UIImage(systemName: "bell"),
            selectedImage: UIImage(systemName: "bell.fill")
        )

        // PROFILE (placeholder)
        let profileVC = UINavigationController(
            rootViewController: PlaceholderViewController(titleText: "Profile")
        )
        profileVC.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )

        viewControllers = [
            homeVC,
            requestsVC,
            notificationsVC,
            profileVC
        ]

        tabBar.tintColor = .systemBlue
        tabBar.backgroundColor = .white
    }
}
