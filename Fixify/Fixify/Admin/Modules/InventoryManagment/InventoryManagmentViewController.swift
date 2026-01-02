import UIKit

final class InventoryManagmentViewController: UIViewController {
    
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
        label.text = "Manage your Inventory\nquickly and easily"
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let viewStockButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(red: 0.28, green: 0.52, blue: 0.93, alpha: 1.0)
        config.cornerStyle = .medium
        
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium)
        config.image = UIImage(systemName: "archivebox.fill", withConfiguration: iconConfig)
        config.imagePlacement = .leading
        config.imagePadding = 15
        
        var titleAttr = AttributedString("View Stock")
        titleAttr.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleAttr.foregroundColor = .white
        config.attributedTitle = titleAttr
        
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25)
        
        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .leading
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let manageStockButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(red: 0.28, green: 0.52, blue: 0.93, alpha: 1.0)
        config.cornerStyle = .medium
        
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium)
        config.image = UIImage(systemName: "pencil", withConfiguration: iconConfig)
        config.imagePlacement = .leading
        config.imagePadding = 15
        
        var titleAttr = AttributedString("Manage Stock")
        titleAttr.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleAttr.foregroundColor = .white
        config.attributedTitle = titleAttr
        
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25)
        
        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .leading
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let trackCostsButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(red: 0.28, green: 0.52, blue: 0.93, alpha: 1.0)
        config.cornerStyle = .medium
        
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium)
        config.image = UIImage(systemName: "dollarsign.circle.fill", withConfiguration: iconConfig)
        config.imagePlacement = .leading
        config.imagePadding = 15
        
        var titleAttr = AttributedString("Track Costs")
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
        // Custom centered title label
        let titleLabel = UILabel()
        titleLabel.text = "Inventory Management"
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
        view.addSubview(viewStockButton)
        view.addSubview(manageStockButton)
        view.addSubview(trackCostsButton)
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 180),
            iconImageView.heightAnchor.constraint(equalToConstant: 180),
            
            subtitleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            viewStockButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 70),
            viewStockButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            viewStockButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            viewStockButton.heightAnchor.constraint(equalToConstant: 65),
            
            manageStockButton.topAnchor.constraint(equalTo: viewStockButton.bottomAnchor, constant: 20),
            manageStockButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            manageStockButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            manageStockButton.heightAnchor.constraint(equalToConstant: 65),
            
            trackCostsButton.topAnchor.constraint(equalTo: manageStockButton.bottomAnchor, constant: 20),
            trackCostsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            trackCostsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            trackCostsButton.heightAnchor.constraint(equalToConstant: 65)
        ])
        
        // Apply dynamic colors
        subtitleLabel.textColor = dynamicTextColor()
    }
    
    private func setupActions() {
        viewStockButton.addTarget(self, action: #selector(viewStockTapped), for: .touchUpInside)
        manageStockButton.addTarget(self, action: #selector(manageStockTapped), for: .touchUpInside)
        trackCostsButton.addTarget(self, action: #selector(trackCostsTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func viewStockTapped() {
        let viewStockVC = ViewStockViewController()
        navigationController?.pushViewController(viewStockVC, animated: true)
    }
    
    @objc private func manageStockTapped() {
        let manageStockVC = ManageStockViewController()
        navigationController?.pushViewController(manageStockVC, animated: true)
    }
    
    @objc private func trackCostsTapped() {
        let trackCostsVC = TrackCostsViewController()
        navigationController?.pushViewController(trackCostsVC, animated: true)
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
