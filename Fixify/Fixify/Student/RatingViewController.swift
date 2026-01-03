import UIKit

// This view controller allows the student to rate a completed request
// The student selects stars and can leave a short comment
final class RatingViewController: UIViewController {

    // ID of the request being rated
    private let requestID: String

    // Stores the selected star rating (1 to 5)
    private var selectedRating = 0

    // Main card view that holds all UI elements
    private let cardView = UIView()

    // Stack view to display star buttons horizontally
    private let starsStack = UIStackView()

    // Text view for student comment
    private let commentView = UITextView()

    // Submit button created from shared UI factory
    private let submitButton = UIFactory.primaryButton(title: "Submit")

    // Custom initializer receives the request ID
    init(requestID: String) {
        self.requestID = requestID
        super.init(nibName: nil, bundle: nil)

        // Present as a popup style view
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    // Required initializer (not used)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Dim background to focus on rating card
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        setupUI()
    }

    // MARK: - UI Setup

    // Builds and layouts the rating card UI
    private func setupUI() {

        // Card styling
        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 16
        cardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardView)

        // Center card on screen
        NSLayoutConstraint.activate([
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])

        // MARK: - Stars Setup

        starsStack.axis = .horizontal
        starsStack.spacing = 8
        starsStack.distribution = .fillEqually

        // Create 5 star buttons
        for i in 1...5 {
            let button = UIButton(type: .system)
            button.tag = i
            button.setImage(UIImage(systemName: "star"), for: .normal)
            button.tintColor = .systemGray
            button.addTarget(self, action: #selector(starTapped(_:)), for: .touchUpInside)
            starsStack.addArrangedSubview(button)
        }

        // MARK: - Comment Setup

        commentView.layer.borderWidth = 1
        commentView.layer.borderColor = UIColor.systemGray4.cgColor
        commentView.layer.cornerRadius = 8
        commentView.text = "Issue fixed quickly."
        commentView.textColor = .secondaryLabel
        commentView.heightAnchor.constraint(equalToConstant: 100).isActive = true

        // Submit button action
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)

        // Stack everything vertically
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

    // MARK: - Actions

    // Called when a star is tapped
    @objc private func starTapped(_ sender: UIButton) {

        // Save selected rating
        selectedRating = sender.tag

        // Update star icons based on selection
        for case let button as UIButton in starsStack.arrangedSubviews {
            let image = button.tag <= selectedRating ? "star.fill" : "star"
            button.setImage(UIImage(systemName: image), for: .normal)
            button.tintColor = .systemYellow
        }
    }

    // Called when submit button is tapped
    @objc private func submitTapped() {

        // Do nothing if no rating selected
        guard selectedRating > 0 else { return }

        // Save rating and comment to the request
        RequestStore.shared.submitRating(
            requestID: requestID,
            rating: selectedRating,
            comment: commentView.text
        )

        // Close the rating popup
        dismiss(animated: true)
    }
}
