import UIKit

final class RatingViewController: UIViewController {

    private let requestID: String
    private var selectedRating = 0

    private let cardView = UIView()
    private let starsStack = UIStackView()
    private let commentView = UITextView()
    private let submitButton = UIFactory.primaryButton(title: "Submit")

    init(requestID: String) {
        self.requestID = requestID
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        setupUI()
    }

    private func setupUI() {

        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 16
        cardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])

        // Stars
        starsStack.axis = .horizontal
        starsStack.spacing = 8
        starsStack.distribution = .fillEqually

        for i in 1...5 {
            let button = UIButton(type: .system)
            button.tag = i
            button.setImage(UIImage(systemName: "star"), for: .normal)
            button.tintColor = .systemGray
            button.addTarget(self, action: #selector(starTapped(_:)), for: .touchUpInside)
            starsStack.addArrangedSubview(button)
        }

        // Comment
        commentView.layer.borderWidth = 1
        commentView.layer.borderColor = UIColor.systemGray4.cgColor
        commentView.layer.cornerRadius = 8
        commentView.text = "Issue fixed quickly."
        commentView.textColor = .secondaryLabel
        commentView.heightAnchor.constraint(equalToConstant: 100).isActive = true

        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            starsStack,
            commentView,
            submitButton
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        cardView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -24),
            stack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24)
        ])
    }

    @objc private func starTapped(_ sender: UIButton) {
        selectedRating = sender.tag

        for case let button as UIButton in starsStack.arrangedSubviews {
            let image = button.tag <= selectedRating ? "star.fill" : "star"
            button.setImage(UIImage(systemName: image), for: .normal)
            button.tintColor = .systemYellow
        }
    }

    @objc private func submitTapped() {
        guard selectedRating > 0 else { return }

        RequestStore.shared.submitRating(
            requestID: requestID,
            rating: selectedRating,
            comment: commentView.text
        )
        


        dismiss(animated: true)
    }
}

