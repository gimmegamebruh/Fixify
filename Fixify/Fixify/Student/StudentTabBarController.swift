import UIKit

final class StudentTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        tabBar.tintColor = .systemBlue
    }

    private func setupTabs() {

        let home = UINavigationController(
            rootViewController: HomeTableViewController()
        )
        home.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )

        let notifications = UINavigationController(
            rootViewController: StudentNotificationsViewController()
        )
        notifications.tabBarItem = UITabBarItem(
            title: "Notifications",
            image: UIImage(systemName: "bell"),
            selectedImage: UIImage(systemName: "bell.fill")
        )

        let chat = UINavigationController(
            rootViewController: ChatListViewController()
        )
        chat.tabBarItem = UITabBarItem(
            title: "Chat",
            image: UIImage(systemName: "bubble.left"),
            selectedImage: UIImage(systemName: "bubble.left.fill")
        )

        let profile = UINavigationController(
            rootViewController: SettingsViewController()
        )
        profile.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )

        viewControllers = [home, notifications, chat, profile]
    }
}

