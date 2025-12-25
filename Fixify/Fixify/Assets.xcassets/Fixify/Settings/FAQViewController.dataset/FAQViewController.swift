import UIKit

final class FAQViewController: UIViewController {
    
    private struct FAQItem {
        let question: String
        let answer: String
        var isExpanded: Bool = false
    }
    
    private var faqItems: [FAQItem] = [
        FAQItem(
            question: "How do I submit a repair request?",
            answer: "Tap \"New Ticket\", fill in the issue details, and press Submit. You'll get a confirmation right away."
        ),
        FAQItem(
            question: "How can I track my ticket status?",
            answer: "Go to My Tickets — each request shows its progress (Pending, In Progress, or Completed)."
        ),
        FAQItem(
            question: "Can I attach photos?",
            answer: "Yes! When creating a ticket, you can attach photos to help explain the issue better."
        ),
        FAQItem(
            question: "How do I cancel or edit a ticket?",
            answer: "Open the ticket →  choose Edit or Cancel."
        ),
        FAQItem(
            question: "How do I contact support?",
            answer: "Go to Settings → Contact Inforamtion"
        )
    ]
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "FAQ"
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        // Back button with dynamic color
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = dynamicTextColor()
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        // Navigation bar appearance with dynamic colors
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = dynamicBackgroundColor()
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
            .foregroundColor: dynamicTextColor(),
            .font: UIFont.systemFont(ofSize: 20, weight: .semibold)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = dynamicTextColor()
        
        // Set view background
        view.backgroundColor = dynamicBackgroundColor()
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = dynamicBackgroundColor()
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        
        tableView.register(FAQQuestionCell.self, forCellReuseIdentifier: "QuestionCell")
        tableView.register(FAQAnswerCell.self, forCellReuseIdentifier: "AnswerCell")
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Dynamic Colors
    
    private func dynamicBackgroundColor() -> UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? .black : .white
        }
    }
    
    private func dynamicTextColor() -> UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? .white : .systemGray
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension FAQViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return faqItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqItems[section].isExpanded ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = faqItems[indexPath.section]
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! FAQQuestionCell
            cell.configure(with: item.question, number: indexPath.section + 1)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath) as! FAQAnswerCell
            cell.configure(with: item.answer)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension FAQViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.row == 0 {
            faqItems[indexPath.section].isExpanded.toggle()
            
            tableView.performBatchUpdates({
                if faqItems[indexPath.section].isExpanded {
                    tableView.insertRows(at: [IndexPath(row: 1, section: indexPath.section)], with: .fade)
                } else {
                    tableView.deleteRows(at: [IndexPath(row: 1, section: indexPath.section)], with: .fade)
                }
            }, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - FAQQuestionCell

class FAQQuestionCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(questionLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            questionLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            questionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            questionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
    
    func configure(with question: String, number: Int) {
        questionLabel.text = "\(number). \(question)"
    }
}

// MARK: - FAQAnswerCell

class FAQAnswerCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.darkGray : .white
        }
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let answerLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? .white : .darkGray
        }
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(answerLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            answerLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            answerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            answerLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            answerLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24)
        ])
    }
    
    func configure(with answer: String) {
        answerLabel.text = answer
    }
}
