import UIKit

final class AdminTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBackground
        vc.title = "Admin"
        viewControllers = [UINavigationController(rootViewController: vc)]
    }
}

