import UIKit

final class TechnicianMetricsViewController: UIViewController {

    // MARK: - Services / Data
    private let technicianService: TechnicianServicing = FirebaseTechnicianService.shared
    private let metricsCalculator = TechnicianMetricsCalculator()
    private let store = RequestStore.shared

    private var technicians: [Technician] = []
    private var selectedTechnicianID: String?

    // MARK: - UI
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let techniciansScroll = UIScrollView()
    private let techniciansStack = UIStackView()

    private let contentCard = UIView()
    private let metricsStack = UIStackView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Technician Management"
        view.backgroundColor = .systemGroupedBackground

        setupScroll()
        setupTechniciansRow()
        setupContentCard()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(requestsChanged),
            name: .technicianRequestsDidChange,
            object: nil
        )

        loadTechnicians()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Setup
    private func setupScroll() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),

            // critical: width equals scroll view width
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32)
        ])
    }

    private func setupTechniciansRow() {

        techniciansScroll.showsHorizontalScrollIndicator = false
        techniciansScroll.translatesAutoresizingMaskIntoConstraints = false
        techniciansScroll.heightAnchor.constraint(equalToConstant: 80).isActive = true

        techniciansStack.axis = .horizontal
        techniciansStack.spacing = 16
        techniciansStack.alignment = .center
        techniciansStack.translatesAutoresizingMaskIntoConstraints = false

        techniciansScroll.addSubview(techniciansStack)

        NSLayoutConstraint.activate([
            techniciansStack.topAnchor.constraint(equalTo: techniciansScroll.contentLayoutGuide.topAnchor),
            techniciansStack.bottomAnchor.constraint(equalTo: techniciansScroll.contentLayoutGuide.bottomAnchor),
            techniciansStack.leadingAnchor.constraint(equalTo: techniciansScroll.contentLayoutGuide.leadingAnchor, constant: 8),
            techniciansStack.trailingAnchor.constraint(equalTo: techniciansScroll.contentLayoutGuide.trailingAnchor, constant: -8),
            techniciansStack.heightAnchor.constraint(equalTo: techniciansScroll.frameLayoutGuide.heightAnchor)
        ])

        contentStack.addArrangedSubview(techniciansScroll)
    }

    private func setupContentCard() {

        contentCard.backgroundColor = .white
        contentCard.layer.cornerRadius = 14
        contentCard.layer.shadowOpacity = 0.08
        contentCard.layer.shadowRadius = 6
        contentCard.layer.shadowOffset = CGSize(width: 0, height: 3)

        metricsStack.axis = .vertical
        metricsStack.spacing = 12
        metricsStack.translatesAutoresizingMaskIntoConstraints = false

        contentCard.addSubview(metricsStack)

        NSLayoutConstraint.activate([
            metricsStack.topAnchor.constraint(equalTo: contentCard.topAnchor, constant: 16),
            metricsStack.leadingAnchor.constraint(equalTo: contentCard.leadingAnchor, constant: 16),
            metricsStack.trailingAnchor.constraint(equalTo: contentCard.trailingAnchor, constant: -16),
            metricsStack.bottomAnchor.constraint(equalTo: contentCard.bottomAnchor, constant: -16)
        ])

        contentStack.addArrangedSubview(contentCard)
    }

    // MARK: - Data Loading
    private func loadTechnicians() {

        technicianService.fetchAll { [weak self] techs in
            //  MUST update UI on main thread
            DispatchQueue.main.async {
                guard let self else { return }

                self.technicians = techs
                self.buildTechnicianCircles()

                // Auto-select first technician so the card is NOT empty
                if self.selectedTechnicianID == nil, let first = techs.first {
                    self.selectTechnician(first)
                } else {
                    // If a tech is already selected, just rebuild metrics
                    self.refreshMetricsIfPossible()
                }
            }
        }
    }

    @objc private func requestsChanged() {
        // When requests snapshot changes, recompute metrics for selected tech
        refreshMetricsIfPossible()
    }

    private func refreshMetricsIfPossible() {
        guard let selectedID = selectedTechnicianID else { return }
        buildMetrics(for: selectedID)
    }

    // MARK: - UI Builders
    private func buildTechnicianCircles() {

        // Clear existing circles
        techniciansStack.arrangedSubviews.forEach { v in
            techniciansStack.removeArrangedSubview(v)
            v.removeFromSuperview()
        }

        if technicians.isEmpty {
            let label = UILabel()
            label.text = "No technicians found"
            label.textColor = .secondaryLabel
            label.font = .systemFont(ofSize: 14)
            techniciansStack.addArrangedSubview(label)
            return
        }

        technicians.forEach { tech in
            let isSelected = (tech.id == selectedTechnicianID)
            let circle = TechnicianCircleView(technician: tech, isSelected: isSelected)
            circle.onSelect = { [weak self] in
                self?.selectTechnician(tech)
            }
            techniciansStack.addArrangedSubview(circle)
        }
    }

    private func selectTechnician(_ technician: Technician) {
        selectedTechnicianID = technician.id
        buildTechnicianCircles()
        buildMetrics(for: technician.id)
    }

    private func buildMetrics(for technicianID: String) {

        // Clear old metrics UI
        metricsStack.arrangedSubviews.forEach { v in
            metricsStack.removeArrangedSubview(v)
            v.removeFromSuperview()
        }

        // Add a loading label (optional but nice)
        let loading = UILabel()
        loading.text = "Loading metrics..."
        loading.textColor = .secondaryLabel
        loading.font = .systemFont(ofSize: 14)
        metricsStack.addArrangedSubview(loading)

        metricsCalculator.calculate(for: technicianID) { [weak self] metrics in
            DispatchQueue.main.async {
                guard let self else { return }

                // Clear loading
                self.metricsStack.arrangedSubviews.forEach { v in
                    self.metricsStack.removeArrangedSubview(v)
                    v.removeFromSuperview()
                }

                let completed = StatCardView(
                    title: "Jobs Completed",
                    value: "\(metrics.totalJobsCompleted)"
                )

                let pending = StatCardView(
                    title: "Pending Jobs",
                    value: "\(metrics.pendingJobs)"
                )

                let avg = StatCardView(
                    title: "Avg Completion Time",
                    value: String(format: "%.1f d", metrics.averageCompletionTime)
                )

                let ratingValue: String
                if metrics.totalReviews == 0 {
                    ratingValue = "No reviews"
                } else {
                    ratingValue = String(format: "%.1f ★", metrics.customerRating)
                }

                let rating = StatCardView(
                    title: "Customer Ratings",
                    value: ratingValue,
                    highlighted: true
                )

                self.metricsStack.addArrangedSubview(completed)
                self.metricsStack.addArrangedSubview(pending)
                self.metricsStack.addArrangedSubview(avg)
                self.metricsStack.addArrangedSubview(rating)
            }
        }
    }
}
