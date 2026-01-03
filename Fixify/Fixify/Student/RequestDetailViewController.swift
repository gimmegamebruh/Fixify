import UIKit


final class RequestDetailViewController: UIViewController {

    // MARK: - Dependencies

    // Shared store that contains all requests
    private let store = RequestStore.shared

    // ID of the request to display
    private let requestID: String

    // MARK: - UI Elements

    // Scroll view to allow scrolling if content is long
    private let scrollView = UIScrollView()

    // Stack view to hold all content vertically
    private let contentStack = UIStackView()

    // Card container for request details
    private let cardView = UIView()

    // Labels for request information
    private let titleLabel = UILabel()
    private let locationLabel = UILabel()
    private let priorityLabel = UILabel()
    private let dateLabel = UILabel()
    private let statusBadge = StatusBadgeView()

    // Image view to show request photo
    private let imageView = UIImageView()

    // ⭐ Rating display UI
    private let ratingLabel = UILabel()
    private let commentLabel = UILabel()

    // Action buttons
    private let editButton = UIFactory.primaryButton(title: "Edit")
    private let cancelButton = UIFactory.secondaryButton(title: "Cancel")
    private let rateButton = UIFactory.primaryButton(title: "Rate")

    // Chat button (shown when request is assigned or active)
    private let chatButton = UIFactory.secondaryButton(title: "Chat")

    // Stack view for buttons
    private let buttonStack = UIStackView()

    // MARK: - Initializer

    // Custom initializer receives request ID
    init(requestID: String) {
        self.requestID = requestID
        super.init(nibName: nil, bundle: nil)
    }

    // Required initializer (not used)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Basic screen setup
        view.backgroundColor = DS.Color.groupedBg
        title = "Request Details"

        // Setup UI and load request data
        setupLayout()
        loadData()

        // Chat button action
        chatButton.addTarget(self, action: #selector(chatTapped), for: .touchUpInside)

        // Listen for updates when technician changes request
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refresh),
            name: .technicianRequestsDidChange,
            object: nil
        )
    }

    // MARK: - Layout Setup

    // Builds the UI layout
    private func setupLayout() {

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        contentStack.axis = .vertical
        contentStack.spacing = DS.Spacing.lg
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: DS.Spacing.lg),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: DS.Spacing.md),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -DS.Spacing.md),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -DS.Spacing.md * 2)
        ])

        // Apply card style
        cardView.dsCard()

        // Labels styling
        titleLabel.font = DS.Font.section()
        locationLabel.font = DS.Font.body()
        priorityLabel.font = DS.Font.body()
        dateLabel.font = DS.Font.caption()
        dateLabel.textColor = DS.Color.subtext

        // Image styling
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = DS.Radius.sm
        imageView.heightAnchor.constraint(equalToConstant: DS.Height.image).isActive = true

        // ⭐ Rating display styling
        ratingLabel.font = .systemFont(ofSize: 22, weight: .bold)
        ratingLabel.textColor = .systemYellow
        ratingLabel.isHidden = true

        commentLabel.font = DS.Font.body()
        commentLabel.numberOfLines = 0
        commentLabel.textColor = DS.Color.text
        commentLabel.isHidden = true

        // Button styling
        cancelButton.backgroundColor = .systemRed
        cancelButton.tintColor = .white

        editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        rateButton.addTarget(self, action: #selector(rateTapped), for: .touchUpInside)

        buttonStack.axis = .horizontal
        buttonStack.spacing = DS.Spacing.md
        buttonStack.distribution = .fillEqually

        // Stack for request info
        let infoStack = UIStackView(arrangedSubviews: [
            titleLabel,
            locationLabel,
            priorityLabel,
            dateLabel,
            statusBadge
        ])
        infoStack.axis = .vertical
        infoStack.spacing = DS.Spacing.sm

        // Main card stack
        let cardStack = UIStackView(arrangedSubviews: [
            infoStack,
            imageView,
            ratingLabel,
            commentLabel,
            buttonStack
        ])
        cardStack.axis = .vertical
        cardStack.spacing = DS.Spacing.md
        cardStack.translatesAutoresizingMaskIntoConstraints = false

        cardView.addSubview(cardStack)

        NSLayoutConstraint.activate([
            cardStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: DS.Spacing.md),
            cardStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -DS.Spacing.md),
            cardStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DS.Spacing.md),
            cardStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -DS.Spacing.md)
        ])

        contentStack.addArrangedSubview(cardView)
    }

    // MARK: - Load Data

    // Loads request data and updates UI
    private func loadData() {
        guard let request = store.requests.first(where: { $0.id == requestID }) else { return }

        titleLabel.text = "Title: \(request.title)"
        locationLabel.text = "Location: \(request.location)"
        priorityLabel.text = "Priority: \(request.priority.rawValue.capitalized)"

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dateLabel.text = "Date: \(formatter.string(from: request.dateCreated))"

        statusBadge.configure(status: request.status)

        // Load request image if available
        imageView.isHidden = request.imageURL == nil
        if let urlString = request.imageURL,
           let url = URL(string: urlString) {

            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data else { return }
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            }.resume()
        }

        // ⭐ Show rating if request was rated
        ratingLabel.isHidden = true
        commentLabel.isHidden = true

        if let rating = request.rating {
            ratingLabel.isHidden = false
            ratingLabel.text = String(repeating: "★", count: rating)

            if let comment = request.ratingComment, !comment.isEmpty {
                commentLabel.isHidden = false
                commentLabel.text = "Comment:\n\(comment)"
            }
        }

        // Update buttons based on request status
        buttonStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        switch request.status {

        case .pending:
            buttonStack.addArrangedSubview(editButton)
            buttonStack.addArrangedSubview(cancelButton)

        case .assigned, .active:
            buttonStack.addArrangedSubview(chatButton)

        case .completed:
            if request.rating == nil {
                buttonStack.addArrangedSubview(rateButton)
            }

        default:
            break
        }
    }

    // MARK: - Actions

    // Opens edit screen
    @objc private func editTapped() {
        let vc = EditRequestViewController(requestID: requestID)
        navigationController?.pushViewController(vc, animated: true)
    }

    // Cancels the request
    @objc private func cancelTapped() {
        store.updateStatus(id: requestID, status: .cancelled)
        navigationController?.popViewController(animated: true)
    }

    // Opens rating popup
    @objc private func rateTapped() {
        let vc = RatingViewController(requestID: requestID)
        present(vc, animated: true)
    }

    // Opens chat screen
    @objc private func chatTapped() {
        let vc = ChatViewController(requestID: requestID)
        navigationController?.pushViewController(vc, animated: true)
    }

    // Reload data when notification is received
    @objc private func refresh() {
        loadData()
    }

    // Remove observer when controller is destroyed
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
