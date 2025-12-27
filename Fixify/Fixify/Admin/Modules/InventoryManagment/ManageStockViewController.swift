import UIKit

final class ManageStockViewController: UIViewController {
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(red: 0.28, green: 0.52, blue: 0.93, alpha: 1.0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let config = UIImage.SymbolConfiguration(pointSize: 80, weight: .regular)
        imageView.image = UIImage(systemName: "list.clipboard.fill", withConfiguration: config)
        
        return imageView
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Manage your Stock\nquickly and easily"
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addItemsButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(red: 0.28, green: 0.52, blue: 0.93, alpha: 1.0)
        config.cornerStyle = .medium
        
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium)
        config.image = UIImage(systemName: "plus.square.fill", withConfiguration: iconConfig)
        config.imagePlacement = .leading
        config.imagePadding = 15
        
        var titleAttr = AttributedString("Add Items")
        titleAttr.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleAttr.foregroundColor = .white
        config.attributedTitle = titleAttr
        
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25)
        
        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .leading
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let updateQuantitiesButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(red: 0.28, green: 0.52, blue: 0.93, alpha: 1.0)
        config.cornerStyle = .medium
        
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium)
        config.image = UIImage(systemName: "arrow.triangle.2.circlepath", withConfiguration: iconConfig)
        config.imagePlacement = .leading
        config.imagePadding = 15
        
        var titleAttr = AttributedString("Update Quantities")
        titleAttr.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleAttr.foregroundColor = .white
        config.attributedTitle = titleAttr
        
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25)
        
        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .leading
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let deleteItemsButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(red: 0.28, green: 0.52, blue: 0.93, alpha: 1.0)
        config.cornerStyle = .medium
        
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium)
        config.image = UIImage(systemName: "trash.fill", withConfiguration: iconConfig)
        config.imagePlacement = .leading
        config.imagePadding = 15
        
        var titleAttr = AttributedString("Delete Items")
        titleAttr.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleAttr.foregroundColor = .white
        config.attributedTitle = titleAttr
        
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25)
        
        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .leading
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupActions()
    }
    
    private func setupNavigationBar() {
        // Back button
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = dynamicTextColor()
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        // Title
        let titleLabel = UILabel()
        titleLabel.text = "Manage Stock"
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
        view.addSubview(iconImageView)
        view.addSubview(subtitleLabel)
        view.addSubview(addItemsButton)
        view.addSubview(updateQuantitiesButton)
        view.addSubview(deleteItemsButton)
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 180),
            iconImageView.heightAnchor.constraint(equalToConstant: 180),
            
            subtitleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            addItemsButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 70),
            addItemsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            addItemsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            addItemsButton.heightAnchor.constraint(equalToConstant: 65),
            
            updateQuantitiesButton.topAnchor.constraint(equalTo: addItemsButton.bottomAnchor, constant: 20),
            updateQuantitiesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            updateQuantitiesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            updateQuantitiesButton.heightAnchor.constraint(equalToConstant: 65),
            
            deleteItemsButton.topAnchor.constraint(equalTo: updateQuantitiesButton.bottomAnchor, constant: 20),
            deleteItemsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            deleteItemsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            deleteItemsButton.heightAnchor.constraint(equalToConstant: 65)
        ])
        
        // Apply dynamic colors
        subtitleLabel.textColor = dynamicTextColor()
    }
    
    private func setupActions() {
        addItemsButton.addTarget(self, action: #selector(addItemsTapped), for: .touchUpInside)
        updateQuantitiesButton.addTarget(self, action: #selector(updateQuantitiesTapped), for: .touchUpInside)
        deleteItemsButton.addTarget(self, action: #selector(deleteItemsTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addItemsTapped() {
        let additemVC = AddItemsViewController()
                navigationController?.pushViewController(additemVC, animated: true)
    }
    
    @objc private func updateQuantitiesTapped() {
        let updateVC = UpdateQuantitiesViewController()
                navigationController?.pushViewController(updateVC, animated: true)
    }
    
    @objc private func deleteItemsTapped() {
        let delitemVC = DeleteItemsViewController()
                navigationController?.pushViewController(delitemVC, animated: true)
    }
    
    // MARK: - Dynamic Colors
    
    private func dynamicBackgroundColor() -> UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? .black : .white
        }
    }
    
    private func dynamicTextColor() -> UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? .white : .black
        }
    }
}
