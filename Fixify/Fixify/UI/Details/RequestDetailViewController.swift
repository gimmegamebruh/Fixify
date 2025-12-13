//
//  RequestDetailViewController.swift
//  Fixify
//
//  Created by Codex on 23/11/2025.
//

import UIKit

final class RequestDetailViewController: UIViewController {

    private let requestID: String
    private let dataStore = TechnicianDataStore.shared

    private let stackView = UIStackView()
    private let descriptionLabel = UILabel()
    private let infoLabel = UILabel()
    private let imageView = UIImageView()
    private let statusLabel = UILabel()
    private let activeButton = UIButton(type: .system)
    private let completeButton = UIButton(type: .system)

    init(requestID: String) {
        self.requestID = requestID
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLayout()
        refresh()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refresh),
                                               name: .technicianRequestsDidChange,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func configureLayout() {
        title = "Request Details"
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)

        infoLabel.numberOfLines = 0
        infoLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        infoLabel.textColor = .secondaryLabel

        statusLabel.font = UIFont.preferredFont(forTextStyle: .headline)

        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemTeal
        imageView.heightAnchor.constraint(equalToConstant: 160).isActive = true

        activeButton.configuration = buttonConfiguration(title: "Mark In Progress", style: .plain())
        activeButton.addTarget(self, action: #selector(handleInProgress), for: .touchUpInside)

        completeButton.configuration = buttonConfiguration(title: "Mark Completed", style: .filled())
        completeButton.addTarget(self, action: #selector(handleCompleted), for: .touchUpInside)

        [imageView, descriptionLabel, infoLabel, statusLabel, activeButton, completeButton].forEach {
            stackView.addArrangedSubview($0)
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    @objc private func refresh() {
        guard let request = dataStore.request(with: requestID) else { return }
        descriptionLabel.text = request.description

        let submission = request.submissionDate.formatted(dateStyle: .medium, timeStyle: .short)
        let details = """
        Location: \(request.location)
        Priority: \(request.priority.rawValue)
        Submitted: \(submission)
        """
        infoLabel.text = details

        statusLabel.text = "Current Status: \(request.status.rawValue)"
        if let systemImage = request.imageName {
            imageView.image = UIImage(systemName: systemImage)
            imageView.isHidden = false
        } else {
            imageView.isHidden = true
        }

        activeButton.isHidden = request.status == .inProgress || request.status == .completed
        completeButton.isHidden = request.status == .completed
    }

    private func buttonConfiguration(title: String, style: UIButton.Configuration) -> UIButton.Configuration {
        var config = style
        config.title = title
        config.cornerStyle = .medium
        return config
    }

    @objc private func handleInProgress() {
        dataStore.markRequestInProgress(requestID)
        alert(message: "Request moved to In Progress.")
    }

    @objc private func handleCompleted() {
        dataStore.markRequestCompleted(requestID)
        alert(message: "Request marked as Completed and parties notified.")
    }

    private func alert(message: String) {
        let controller = UIAlertController(title: "Status Updated",
                                           message: message,
                                           preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default))
        present(controller, animated: true)
    }
}
