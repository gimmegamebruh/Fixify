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
        window.rootViewController = UINavigationController(
            rootViewController: LoginViewController()
        )
        window.makeKeyAndVisible()
        self.window = window
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance

    }

    // MARK: - Routing
    static func switchToRole(_ role: UserRole) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = scene.delegate as? SceneDelegate else { return }

        DispatchQueue.main.async {
            let rootVC: UIViewController

            switch role {
            case .student:
                rootVC = StudentTabBarController()
            case .technician:
                rootVC = TechnicianTabBarController()
            case .admin:
                rootVC = AdminTabBarController()
            }

            delegate.window?.rootViewController = rootVC
        }
    }


    static func switchToLogin() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = scene.delegate as? SceneDelegate else { return }

        DispatchQueue.main.async {
            delegate.window?.rootViewController =
                UINavigationController(rootViewController: LoginViewController())
        }
    }

}

