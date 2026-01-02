//
//  AdminDashboardViewController.swift
//  Fixify
//

import UIKit

final class AdminDashboardViewController: UIViewController {

    private let viewModel = AdminDashboardViewModel()

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let cardsStack = UIStackView()
    private let escalatedCountLabel = UILabel()

    private let totalCard =
        StatCardView(title: "Total Requests", value: "0")

    private let completedCard =
        StatCardView(title: "Completed", value: "0")

    private let pendingCard =
        StatCardView(title: "Pending", value: "0")

    private let avgCard =
        StatCardView(
            title: "Avg Time",
            value: "0d",
            highlighted: true
        )

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Admin Dashboard"
        view.backgroundColor = .systemGroupedBackground

        setupScroll()
        setupUI()
        updateStats() 

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dataDidChange),
            name: .technicianRequestsDidChange,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Data Updates

    @objc private func dataDidChange() {
        DispatchQueue.main.async {
            self.updateStats()
            self.rebuildEscalatedCards()
        }
    }

    private func updateStats() {
        totalCard.updateValue("\(viewModel.totalRequests)")
        completedCard.updateValue("\(viewModel.completedRequests)")
        pendingCard.updateValue("\(viewModel.pendingRequests)")
        avgCard.updateValue(viewModel.averageCompletionText)
    }

    // MARK: - Scroll Setup

    private func setupScroll() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    // MARK: - UI Setup

    private func setupUI() {

        let statsGrid = UIStackView(arrangedSubviews: [
            makeRow(totalCard, completedCard),
            makeRow(pendingCard, avgCard)
        ])
        statsGrid.axis = .vertical
        statsGrid.spacing = 16

        let addTech = primaryButton("Add New Technician")

        let inventory = primaryButton("Manage Inventory")
        inventory.addTarget(
            self,
            action: #selector(manageInventoryTapped),
            for: .touchUpInside
        )

        let metrics = primaryButton("View Technician Metrics")
        metrics.addTarget(
            self,
            action: #selector(viewTechnicianMetricsTapped),
            for: .touchUpInside
        )

        let issuePatterns = primaryButton("Issue Pattern Analytics")
        issuePatterns.addTarget(
            self,
            action: #selector(viewIssuePatternsTapped),
            for: .touchUpInside
        )

        let header = escalatedSectionHeader()

        cardsStack.axis = .vertical
        cardsStack.spacing = 12

        let mainStack = UIStackView(arrangedSubviews: [
            statsGrid,
            addTech,
            inventory,
            metrics,
            issuePatterns,
            header,
            cardsStack
        ])

        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])

        rebuildEscalatedCards()
    }

    // MARK: - Escalated Section

    private func escalatedSectionHeader() -> UIView {

        escalatedCountLabel.font = .boldSystemFont(ofSize: 18)
        escalatedCountLabel.text =
            "Escalated Requests (\(viewModel.escalatedRequests.count))"

        let viewAll = UIButton(type: .system)
        viewAll.setTitle("View All", for: .normal)
        viewAll.addTarget(
            self,
            action: #selector(viewAllTapped),
            for: .touchUpInside
        )

        let stack = UIStackView(arrangedSubviews: [
            escalatedCountLabel,
            UIView(),
            viewAll
        ])
        stack.axis = .horizontal

        return stack
    }

    private func rebuildEscalatedCards() {

        escalatedCountLabel.text =
            "Escalated Requests (\(viewModel.escalatedRequests.count))"

        cardsStack.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }

        viewModel.escalatedRequests.forEach { request in
            let card = EscalatedRequestCard(request: request)
            card.onViewTap = { [weak self] in
                let vc = EscalationDetailViewController(request: request)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            cardsStack.addArrangedSubview(card)
        }
    }

    // MARK: - Actions

    @objc private func manageInventoryTapped() {
        let vc = InventoryManagmentViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func viewAllTapped() {
        let vc = EscalatedRequestsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func viewTechnicianMetricsTapped() {
        let vc = TechnicianMetricsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func viewIssuePatternsTapped() {
        let vc = IssuePatternViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Helpers

    private func makeRow(_ a: UIView, _ b: UIView) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [a, b])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }

    private func primaryButton(_ title: String) -> UIButton {
        let b = UIButton(type: .system)
        b.setTitle(title, for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = .systemBlue
        b.layer.cornerRadius = 14
        b.heightAnchor.constraint(equalToConstant: 52).isActive = true
        return b
    }
}
