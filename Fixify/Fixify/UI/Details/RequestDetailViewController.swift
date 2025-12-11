import UIKit

class RequestDetailViewController: UIViewController {

    private let store = RequestStore.shared
    private let index: Int

    // UI elements
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()

    private let titleLabel = UILabel()
    private let statusLabel = UILabel()
    private let locationLabel = UILabel()
    private let priorityLabel = UILabel()
    private let categoryLabel = UILabel()
    private let dateLabel = UILabel()
    private let descriptionTitleLabel = UILabel()
    private let descriptionLabel = UILabel()

    private let editButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)

    init(requestIndex: Int) {
        self.index = requestIndex
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Details"

        setupScroll()
        setupLabels()
        setupButtons()
        layoutUI()
        refreshUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshUI()
    }

    private func setupScroll() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        contentView.axis = .vertical
        contentView.spacing = 12
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }

    private func setupLabels() {
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0

        statusLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        statusLabel.textAlignment = .center
        statusLabel.layer.cornerRadius = 10
        statusLabel.clipsToBounds = true
        statusLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true

        [locationLabel, priorityLabel, categoryLabel, dateLabel].forEach {
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = .label
            $0.numberOfLines = 0
        }

        descriptionTitleLabel.text = "Description"
        descriptionTitleLabel.font = .boldSystemFont(ofSize: 18)

        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
    }

    private func setupButtons() {
        editButton.setTitle("Edit Request", for: .normal)
        editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)

        cancelButton.setTitle("Cancel Request", for: .normal)
        cancelButton.setTitleColor(.systemRed, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
    }

    private func layoutUI() {
        contentView.addArrangedSubview(titleLabel)
        contentView.addArrangedSubview(statusLabel)
        contentView.addArrangedSubview(locationLabel)
        contentView.addArrangedSubview(priorityLabel)
        contentView.addArrangedSubview(categoryLabel)
        contentView.addArrangedSubview(dateLabel)
        contentView.addArrangedSubview(descriptionTitleLabel)
        contentView.addArrangedSubview(descriptionLabel)
        contentView.setCustomSpacing(20, after: descriptionLabel)
        contentView.addArrangedSubview(editButton)
        contentView.addArrangedSubview(cancelButton)
    }

    private func refreshUI() {
        let request = store.request(at: index)

        titleLabel.text = request.title
        locationLabel.text = "Location: \(request.location)"
        priorityLabel.text = "Priority: \(request.priority)"
        categoryLabel.text = "Category: \(request.category)"

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dateLabel.text = "Date: \(formatter.string(from: request.dateCreated))"

        descriptionLabel.text = request.description

        statusLabel.text = request.status.displayName
        statusLabel.backgroundColor = request.status.color
        statusLabel.textColor = .white

        switch request.status {
        case .pending:
            editButton.isHidden = false
            cancelButton.isHidden = false
        case .active:
            editButton.isHidden = true
            cancelButton.isHidden = true
        case .completed, .cancelled:
            editButton.isHidden = true
            cancelButton.isHidden = true
        }
    }

    @objc private func editTapped() {
        let editVC = EditRequestViewController(requestIndex: index)
        navigationController?.pushViewController(editVC, animated: true)
    }

    @objc private func cancelTapped() {
        store.cancel(at: index)
        navigationController?.popViewController(animated: true)
    }
}

