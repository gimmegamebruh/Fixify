import UIKit

final class TechnicianTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .systemBlue
        setupTabs()
    }

    private func setupTabs() {
        let dashboard = UINavigationController(rootViewController: TechnicianRequestsViewController())
        dashboard.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )

        let notifications = UINavigationController(rootViewController: TechnicianNotificationsViewController())
        notifications.tabBarItem = UITabBarItem(
            title: "Notifications",
            image: UIImage(systemName: "bell"),
            selectedImage: UIImage(systemName: "bell.fill")
        )

        let chat = UINavigationController(rootViewController: ChatListViewController())
        chat.tabBarItem = UITabBarItem(
            title: "Chat",
            image: UIImage(systemName: "bubble.left"),
            selectedImage: UIImage(systemName: "bubble.left.fill")
        )

        let profile = UINavigationController(rootViewController: ProfileViewController())
        profile.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )

        viewControllers = [
            dashboard,
            notifications,
            chat,
            profile
        ]
    }
}
