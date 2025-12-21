//
//  TechnicianMetricsViewController.swift
//  Fixify
//

import UIKit

final class TechnicianMetricsViewController: UIViewController {

    // MARK: - State
    private var technicians: [Technician] = []
    private var selectedTechnicianID: String?

    private let calculator = TechnicianMetricsCalculator()

    // MARK: - UI
    private let scrollView = UIScrollView()
    private let techStack = UIStackView()
    private let contentCard = UIView()
    private let metricsStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Technician Management"
        view.backgroundColor = .systemGroupedBackground

        setupScroll()
        setupContentCard()
        loadTechnicians()
        observeRequestChanges() // 🔥 NEW
    }

    // MARK: - Firebase Updates
    private func observeRequestChanges() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshMetrics),
            name: .technicianRequestsDidChange,
            object: nil
        )
    }

    @objc private func refreshMetrics() {
        guard
            let id = selectedTechnicianID,
            let tech = technicians.first(where: { $0.id == id })
        else { return }

        buildMetrics(for: tech)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Load
    private func loadTechnicians() {
        LocalTechnicianService.shared.fetchAll { [weak self] techs in
            guard let self else { return }
            self.technicians = techs
            self.buildTechnicianCircles()

            // Auto-select first technician
            if let first = techs.first {
                self.selectTechnician(first)
            }
        }
    }

    // MARK: - Horizontal Selector
    private func setupScroll() {
        scrollView.showsHorizontalScrollIndicator = false

        techStack.axis = .horizontal
        techStack.spacing = 16
        techStack.alignment = .center

        scrollView.addSubview(techStack)
        view.addSubview(scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        techStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.heightAnchor.constraint(equalToConstant: 90),

            techStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            techStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            techStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            techStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
    }

    private func buildTechnicianCircles() {
        techStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        technicians.forEach { technician in
            let view = TechnicianCircleView(
                technician: technician,
                isSelected: technician.id == selectedTechnicianID
            )
            view.onSelect = { [weak self] in
                self?.selectTechnician(technician)
            }
            techStack.addArrangedSubview(view)
        }
    }

    // MARK: - Content Card
    private func setupContentCard() {
        contentCard.backgroundColor = .white
        contentCard.layer.cornerRadius = 16
        contentCard.layer.shadowOpacity = 0.08
        contentCard.layer.shadowRadius = 6
        contentCard.layer.shadowOffset = CGSize(width: 0, height: 3)

        metricsStack.axis = .vertical
        metricsStack.spacing = 16

        view.addSubview(contentCard)
        contentCard.addSubview(metricsStack)

        contentCard.translatesAutoresizingMaskIntoConstraints = false
        metricsStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentCard.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 24),
            contentCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentCard.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -24),

            metricsStack.topAnchor.constraint(equalTo: contentCard.topAnchor, constant: 24),
            metricsStack.leadingAnchor.constraint(equalTo: contentCard.leadingAnchor, constant: 16),
            metricsStack.trailingAnchor.constraint(equalTo: contentCard.trailingAnchor, constant: -16),
            metricsStack.bottomAnchor.constraint(equalTo: contentCard.bottomAnchor, constant: -24)
        ])
    }

    // MARK: - Selection
    private func selectTechnician(_ technician: Technician) {
        selectedTechnicianID = technician.id
        buildTechnicianCircles()
        buildMetrics(for: technician)
    }

    private func buildMetrics(for technician: Technician) {
        metricsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        calculator.calculate(for: technician.id) { [weak self] metrics in
            DispatchQueue.main.async {

                let row1 = self?.makeRow(
                    StatCardView(
                        title: "Total Jobs Completed",
                        value: "\(metrics.totalJobsCompleted)"
                    ),
                    StatCardView(
                        title: "Pending Jobs",
                        value: "\(metrics.pendingJobs)"
                    )
                )

                let row2 = self?.makeRow(
                    StatCardView(
                        title: "Avg Completion Time",
                        value: "\(Int(metrics.averageCompletionTime))d"
                    ),
                    StatCardView(
                        title: "Total Jobs",
                        value: "\(metrics.totalJobsCompleted)"
                    )
                )

                let rating = StatCardView(
                    title: "Customer Ratings",
                    value: "—"
                )

                [row1, row2, rating]
                    .compactMap { $0 }
                    .forEach { self?.metricsStack.addArrangedSubview($0) }
            }
        }
    }

    private func makeRow(_ left: UIView, _ right: UIView) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [left, right])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }
}
