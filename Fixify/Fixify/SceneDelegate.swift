import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {

        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)

        // Root = NavigationController(HomeViewController)
        let homeVC = HomeViewController()
        let nav = UINavigationController(rootViewController: homeVC)

        window.rootViewController = nav
        window.makeKeyAndVisible()
        self.window = window
    }
}

