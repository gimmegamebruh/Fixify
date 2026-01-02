import UIKit

final class AdminTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    private func setupTabs() {

        // 🔥 ADMIN DASHBOARD (REAL)
        let homeVC = UINavigationController(
            rootViewController: AdminDashboardViewController()
        )
        homeVC.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )

        // 🔥 ADMIN REQUESTS (REAL)
        let requestsVC = UINavigationController(
            rootViewController: AllRequestsViewController()
        )
        requestsVC.tabBarItem = UITabBarItem(
            title: "Requests",
            image: UIImage(systemName: "doc.text"),
            selectedImage: UIImage(systemName: "doc.text.fill")
        )

        let notificationsVC = UINavigationController(
            rootViewController: AdminNotificationsViewController()
        )

        notificationsVC.tabBarItem = UITabBarItem(
            title: "Notifications",
            image: UIImage(systemName: "bell"),
            selectedImage: UIImage(systemName: "bell.fill")
        )

        let profileVC = UINavigationController(
            rootViewController: SettingsViewController()
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
