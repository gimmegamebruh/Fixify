import UIKit

final class TechnicianHistoryViewController: UITableViewController {

    private let store = RequestStore.shared

    private var completed: [Request] {
        store.requests.filter { request in
            if request.status != .completed { return false }
            if CurrentUser.role == .technician, let techID = CurrentUser.userID {
                return request.assignedTechnicianID == techID
            }
            return CurrentUser.role != .technician
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Completed Jobs"
        tableView.register(TechnicianHistoryCell.self, forCellReuseIdentifier: TechnicianHistoryCell.reuseID)
        tableView.separatorStyle = .none
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reload),
            name: .technicianRequestsDidChange,
            object: nil
        )
    }

    @objc private func reload() { tableView.reloadData() }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        completed.count
    }

    override func tableView(_: UITableView, cellForRowAt index: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TechnicianHistoryCell.reuseID,
            for: index
        ) as? TechnicianHistoryCell else { return UITableViewCell() }
        cell.configure(with: completed[index.row])
        return cell
    }

    override func tableView(_: UITableView, didSelectRowAt index: IndexPath) {
        let request = completed[index.row]
        let detail = TechnicianRequestDetailViewController(request: request)
        navigationController?.pushViewController(detail, animated: true)
    }
}

private final class TechnicianHistoryCell: UITableViewCell {

    static let reuseID = "TechnicianHistoryCell"

    private let titleLabel = UILabel()
    private let locationLabel = UILabel()
    private let ratingLabel = UILabel()
    private let resolutionLabel = UILabel()
    private let container = UIView()
    private let photoView = UIImageView()
    private var imageTask: URLSessionDataTask?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(with request: Request) {
        titleLabel.text = request.title
        locationLabel.text = request.location
        resolutionLabel.text = "Finished: \(formatted(date: request.scheduledTime ?? request.dateCreated))"

        if let rating = request.rating {
            ratingLabel.text = "Rating: \(String(repeating: "★", count: rating))"
            ratingLabel.textColor = .systemYellow
        } else {
            ratingLabel.text = "No rating yet"
            ratingLabel.textColor = .tertiaryLabel
        }

        imageTask?.cancel()
        photoView.image = nil
        if let urlString = request.imageURL,
           let url = URL(string: urlString) {
            photoView.isHidden = false
            imageTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let data, let self else { return }
                DispatchQueue.main.async {
                    self.photoView.image = UIImage(data: data)
                }
            }
            imageTask?.resume()
        } else {
            photoView.isHidden = true
        }
    }

    private func setup() {
        container.layer.cornerRadius = 12
        container.backgroundColor = .systemBackground
        container.layer.borderWidth = 2
        container.layer.borderColor = UIColor.separator.withAlphaComponent(0.8).cgColor
        container.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .boldSystemFont(ofSize: 17)
        locationLabel.font = .systemFont(ofSize: 14)
        locationLabel.textColor = .secondaryLabel

        ratingLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        resolutionLabel.font = .systemFont(ofSize: 12)
        resolutionLabel.textColor = .tertiaryLabel

        photoView.contentMode = .scaleAspectFill
        photoView.clipsToBounds = true
        photoView.layer.cornerRadius = 10
        photoView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        photoView.backgroundColor = .secondarySystemBackground

        let stack = UIStackView(arrangedSubviews: [photoView, titleLabel, locationLabel, resolutionLabel, ratingLabel])
        stack.axis = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(container)
        container.addSubview(stack)

        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 14),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -14),
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])
    }

    private func formatted(date: Date) -> String {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df.string(from: date)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        photoView.image = nil
        photoView.isHidden = true
    }
}
