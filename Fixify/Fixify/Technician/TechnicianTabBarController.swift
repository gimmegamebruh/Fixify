import UIKit

final class TechnicianTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [
            UINavigationController(rootViewController: TechnicianRequestsViewController())
        ]
    }
}

