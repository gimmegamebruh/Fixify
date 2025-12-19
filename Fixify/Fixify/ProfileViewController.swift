import UIKit

final class ProfileViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 60
        imageView.backgroundColor = .systemGray5
        imageView.image = UIImage(systemName: "person.crop.circle")
        imageView.tintColor = .systemGray3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let infoCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name: John Doe"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let studentIdLabel: UILabel = {
        let label = UILabel()
        label.text = "Student ID: 12345678"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email: 123456@gmail.com"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contactLabel: UILabel = {
        let label = UILabel()
        label.text = "Contact Number: 12345678"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
    }
    
    private func setupNavigationBar() {
        // Back button with dynamic color
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = dynamicTextColor()
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        // Custom centered title label
        let titleLabel = UILabel()
        titleLabel.text = "Profile"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = dynamicTextColor()
        titleLabel.textAlignment = .center
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        
        // Navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = dynamicBackgroundColor()
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = dynamicTextColor()
        
        view.backgroundColor = dynamicBackgroundColor()
    }
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(infoCardView)
        
        // Add labels to info card
        infoCardView.addSubview(nameLabel)
        infoCardView.addSubview(studentIdLabel)
        infoCardView.addSubview(emailLabel)
        infoCardView.addSubview(contactLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            
            infoCardView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40),
            infoCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            infoCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            infoCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            nameLabel.topAnchor.constraint(equalTo: infoCardView.topAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: infoCardView.trailingAnchor, constant: -20),
            
            studentIdLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            studentIdLabel.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor, constant: 20),
            studentIdLabel.trailingAnchor.constraint(equalTo: infoCardView.trailingAnchor, constant: -20),
            
            emailLabel.topAnchor.constraint(equalTo: studentIdLabel.bottomAnchor, constant: 16),
            emailLabel.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: infoCardView.trailingAnchor, constant: -20),
            
            contactLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 16),
            contactLabel.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor, constant: 20),
            contactLabel.trailingAnchor.constraint(equalTo: infoCardView.trailingAnchor, constant: -20),
            contactLabel.bottomAnchor.constraint(equalTo: infoCardView.bottomAnchor, constant: -24)
        ])
        
        // Apply dynamic colors
        nameLabel.textColor = dynamicTextColor()
        studentIdLabel.textColor = dynamicTextColor()
        emailLabel.textColor = dynamicTextColor()
        contactLabel.textColor = dynamicTextColor()
        
        // Update card background for dark mode
        infoCardView.backgroundColor = dynamicCardBackgroundColor()
    }
    
    // MARK: - Dynamic Colors
    
    private func dynamicBackgroundColor() -> UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? .black : .systemGray6
        }
    }
    
    private func dynamicTextColor() -> UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? .white : .black
        }
    }
    
    private func dynamicCardBackgroundColor() -> UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? .darkGray : .white
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
