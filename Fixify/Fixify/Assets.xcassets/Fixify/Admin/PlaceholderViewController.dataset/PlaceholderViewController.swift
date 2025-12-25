import UIKit

final class PlaceholderViewController: UIViewController {

    private let titleText: String

    init(titleText: String) {
        self.titleText = titleText
        super.init(nibName: nil, bundle: nil)
        self.title = titleText
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
    }
}
