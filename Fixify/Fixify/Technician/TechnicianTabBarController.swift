import UIKit

final class TechnicianTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .systemBlue
        setupTabs()
    }

    private func setupTabs() {

        let dashboard = UINavigationController(
            rootViewController: TechnicianRequestsViewController()
        )
        dashboard.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )

        let schedule = UINavigationController(
            rootViewController: TechnicianScheduleViewController()
        )
        schedule.tabBarItem = UITabBarItem(
            title: "Schedule",
            image: UIImage(systemName: "calendar"),
            selectedImage: UIImage(systemName: "calendar.circle.fill")
        )

        let history = UINavigationController(
            rootViewController: TechnicianHistoryViewController()
        )
        history.tabBarItem = UITabBarItem(
            title: "Completed",
            image: UIImage(systemName: "checkmark.circle"),
            selectedImage: UIImage(systemName: "checkmark.circle.fill")
        )

        // 🔥 NEW CHAT TAB
        let chat = UINavigationController(
            rootViewController: ChatListViewController()
        )
        chat.tabBarItem = UITabBarItem(
            title: "Chat",
            image: UIImage(systemName: "bubble.left"),
            selectedImage: UIImage(systemName: "bubble.left.fill")
        )

        let notifications = UINavigationController(
            rootViewController: NotificationsViewController()
        )
        notifications.tabBarItem = UITabBarItem(
            title: "Notifications",
            image: UIImage(systemName: "bell"),
            selectedImage: UIImage(systemName: "bell.fill")
        )

        let profile = UINavigationController(
            rootViewController: SettingsViewController()
        )
        profile.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )

        viewControllers = [
            dashboard,
            schedule,
            history,
            chat,        
            notifications,
            profile
        ]
    }
}
