import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)

        let homeNav = UINavigationController(
            rootViewController: AdminDashboardViewController()
        )
        homeNav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            tag: 0
        )

        let requestsNav = UINavigationController(
            rootViewController: AllRequestsViewController()
        )
        requestsNav.tabBarItem = UITabBarItem(
            title: "All Requests",
            image: UIImage(systemName: "doc.text"),
            tag: 1
        )

        let notificationsVC = UIViewController()
        notificationsVC.view.backgroundColor = .systemBackground
        notificationsVC.tabBarItem = UITabBarItem(
            title: "Notifications",
            image: UIImage(systemName: "bell"),
            tag: 2
        )

        let profileVC = UIViewController()
        profileVC.view.backgroundColor = .systemBackground
        profileVC.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            tag: 3
        )

        let tabBar = UITabBarController()
        tabBar.viewControllers = [
            homeNav,
            requestsNav,
            notificationsVC,
            profileVC
        ]

        window.rootViewController = tabBar
        window.makeKeyAndVisible()
        self.window = window
    }
}
