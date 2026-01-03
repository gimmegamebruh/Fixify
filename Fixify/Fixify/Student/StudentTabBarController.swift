import UIKit

// This tab bar controller manages the main navigation for the student side
// It contains Home, Notifications, Chat, and Settings tabs
final class StudentTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup all tabs when the tab bar loads
        setupTabs()

        // Set selected tab color
        tabBar.tintColor = .systemBlue
    }

    // Creates and configures all tab bar items
    private func setupTabs() {

        // Home tab - shows student's requests
        let home = UINavigationController(
            rootViewController: HomeTableViewController()
        )
        home.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )

        // Notifications tab - shows updates about requests
        let notifications = UINavigationController(
            rootViewController: StudentNotificationsViewController()
        )
        notifications.tabBarItem = UITabBarItem(
            title: "Notifications",
            image: UIImage(systemName: "bell"),
            selectedImage: UIImage(systemName: "bell.fill")
        )

        // Chat tab - allows student to chat with technician
        let chat = UINavigationController(
            rootViewController: ChatListViewController()
        )
        chat.tabBarItem = UITabBarItem(
            title: "Chat",
            image: UIImage(systemName: "bubble.left"),
            selectedImage: UIImage(systemName: "bubble.left.fill")
        )

        // Settings tab - student profile and app settings
        let profile = UINavigationController(
            rootViewController: SettingsViewController()
        )
        profile.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )

        // Assign all tabs to the tab bar
        viewControllers = [home, notifications, chat, profile]
    }
}
