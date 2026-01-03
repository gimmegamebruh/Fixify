import UIKit

final class AdminTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    private func setupTabs() {

        let homeVC = UINavigationController(
            rootViewController: AdminDashboardViewController()
        )
        homeVC.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )

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
            title: "Settings",
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
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
