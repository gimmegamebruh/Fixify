import UIKit

final class EditQuantityViewController: UIViewController {
    
    private let productCode: String
    private var currentQuantity: Int = 10
    private var newQuantity: Int = 187
    
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
    
    private let itemNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Ethernet Cabel"
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let codeLabel: UILabel = {
        let label = UILabel()
        label.text = "Code : 1"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let currentQuantityValueLabel: UILabel = {
        let label = UILabel()
        label.text = "10"
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let currentQuantityLabel: UILabel = {
        let label = UILabel()
        label.text = "Current Quantity"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let quantityControlsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let decreaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        button.tintColor = .systemGray3
        let config = UIImage.SymbolConfiguration(pointSize: 44, weight: .regular)
        button.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let quantityTextField: UITextField = {
        let textField = UITextField()
        textField.text = "187"
        textField.font = UIFont.systemFont(ofSize: 36, weight: .semibold)
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let increaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = .systemGray3
        let config = UIImage.SymbolConfiguration(pointSize: 44, weight: .regular)
        button.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let updateLabel: UILabel = {
        let label = UILabel()
        label.text = "Update"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let confirmButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(red: 0.28, green: 0.52, blue: 0.93, alpha: 1.0)
        config.cornerStyle = .medium
        
        var titleAttr = AttributedString("Confirm")
        titleAttr.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleAttr.foregroundColor = .white
        config.attributedTitle = titleAttr
        
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 50, bottom: 12, trailing: 50)
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // Tab Bar
    private let tabBarContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let homeButton = TabBarButton(icon: "house", title: "Home", isSelected: false)
    private let notificationsButton = TabBarButton(icon: "bell", title: "Notifications", isSelected: false)
    private let profileButton = TabBarButton(icon: "person", title: "Profile", isSelected: false)
    private let settingsButton = TabBarButton(icon: "gearshape", title: "Settings", isSelected: false)
    
    init(productCode: String) {
        self.productCode = productCode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupActions()
        updateQuantityDisplay()
        
        // Dismiss keyboard on tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
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
        titleLabel.text = "Update Quantities"
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
        
        contentView.addSubview(itemNameLabel)
        contentView.addSubview(codeLabel)
        contentView.addSubview(currentQuantityValueLabel)
        contentView.addSubview(currentQuantityLabel)
        contentView.addSubview(quantityControlsContainer)
        contentView.addSubview(confirmButton)
        
        quantityControlsContainer.addSubview(decreaseButton)
        quantityControlsContainer.addSubview(quantityTextField)
        quantityControlsContainer.addSubview(increaseButton)
        quantityControlsContainer.addSubview(updateLabel)
        
        view.addSubview(tabBarContainer)
        tabBarContainer.addSubview(homeButton)
        tabBarContainer.addSubview(notificationsButton)
        tabBarContainer.addSubview(profileButton)
        tabBarContainer.addSubview(settingsButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: tabBarContainer.topAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            itemNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            itemNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            itemNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            codeLabel.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: 8),
            codeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            codeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            currentQuantityValueLabel.topAnchor.constraint(equalTo: codeLabel.bottomAnchor, constant: 80),
            currentQuantityValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            
            currentQuantityLabel.topAnchor.constraint(equalTo: currentQuantityValueLabel.bottomAnchor, constant: 8),
            currentQuantityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            
            quantityControlsContainer.topAnchor.constraint(equalTo: currentQuantityLabel.bottomAnchor, constant: 60),
            quantityControlsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            quantityControlsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            quantityControlsContainer.heightAnchor.constraint(equalToConstant: 80),
            
            decreaseButton.leadingAnchor.constraint(equalTo: quantityControlsContainer.leadingAnchor),
            decreaseButton.centerYAnchor.constraint(equalTo: quantityTextField.centerYAnchor),
            decreaseButton.widthAnchor.constraint(equalToConstant: 50),
            decreaseButton.heightAnchor.constraint(equalToConstant: 50),
            
            quantityTextField.centerXAnchor.constraint(equalTo: quantityControlsContainer.centerXAnchor, constant: -30),
            quantityTextField.topAnchor.constraint(equalTo: quantityControlsContainer.topAnchor),
            quantityTextField.widthAnchor.constraint(equalToConstant: 100),
            
            increaseButton.leadingAnchor.constraint(equalTo: quantityTextField.trailingAnchor, constant: 20),
            increaseButton.centerYAnchor.constraint(equalTo: quantityTextField.centerYAnchor),
            increaseButton.widthAnchor.constraint(equalToConstant: 50),
            increaseButton.heightAnchor.constraint(equalToConstant: 50),
            
            updateLabel.leadingAnchor.constraint(equalTo: increaseButton.trailingAnchor, constant: 20),
            updateLabel.centerYAnchor.constraint(equalTo: quantityTextField.centerYAnchor),
            updateLabel.trailingAnchor.constraint(equalTo: quantityControlsContainer.trailingAnchor),
            
            confirmButton.topAnchor.constraint(equalTo: quantityControlsContainer.bottomAnchor, constant: 80),
            confirmButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            // Tab Bar
            tabBarContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabBarContainer.heightAnchor.constraint(equalToConstant: 90),
            
            homeButton.leadingAnchor.constraint(equalTo: tabBarContainer.leadingAnchor, constant: 10),
            homeButton.topAnchor.constraint(equalTo: tabBarContainer.topAnchor, constant: 10),
            homeButton.widthAnchor.constraint(equalTo: tabBarContainer.widthAnchor, multiplier: 0.22),
            
            notificationsButton.leadingAnchor.constraint(equalTo: homeButton.trailingAnchor, constant: 10),
            notificationsButton.topAnchor.constraint(equalTo: tabBarContainer.topAnchor, constant: 10),
            notificationsButton.widthAnchor.constraint(equalTo: tabBarContainer.widthAnchor, multiplier: 0.22),
            
            profileButton.leadingAnchor.constraint(equalTo: notificationsButton.trailingAnchor, constant: 10),
            profileButton.topAnchor.constraint(equalTo: tabBarContainer.topAnchor, constant: 10),
            profileButton.widthAnchor.constraint(equalTo: tabBarContainer.widthAnchor, multiplier: 0.22),
            
            settingsButton.leadingAnchor.constraint(equalTo: profileButton.trailingAnchor, constant: 10),
            settingsButton.topAnchor.constraint(equalTo: tabBarContainer.topAnchor, constant: 10),
            settingsButton.widthAnchor.constraint(equalTo: tabBarContainer.widthAnchor, multiplier: 0.22)
        ])
        
        // Apply dynamic colors
        itemNameLabel.textColor = dynamicTextColor()
        quantityTextField.textColor = dynamicTextColor()
        currentQuantityValueLabel.textColor = dynamicTextColor()
        updateLabel.textColor = dynamicTextColor()
        tabBarContainer.backgroundColor = dynamicTabBarBackgroundColor()
    }
    
    private func setupActions() {
        decreaseButton.addTarget(self, action: #selector(decreaseQuantity), for: .touchUpInside)
        increaseButton.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        quantityTextField.addTarget(self, action: #selector(quantityTextChanged), for: .editingChanged)
        
        homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        notificationsButton.addTarget(self, action: #selector(notificationsButtonTapped), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
    }
    
    private func updateQuantityDisplay() {
        quantityTextField.text = "\(newQuantity)"
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func decreaseQuantity() {
        if newQuantity > 0 {
            newQuantity -= 1
            updateQuantityDisplay()
        }
    }
    
    @objc private func increaseQuantity() {
        newQuantity += 1
        updateQuantityDisplay()
    }
    
    @objc private func quantityTextChanged() {
        if let text = quantityTextField.text, let value = Int(text) {
            newQuantity = value
        }
    }
    
    @objc private func confirmTapped() {
        // Show success popup
        showSuccessPopup()
    }
    
    private func showSuccessPopup() {
        let alert = UIAlertController(title: "Updates Made", message: nil, preferredStyle: .alert)
        
        let closeAction = UIAlertAction(title: "Close", style: .default) { [weak self] _ in
            // Navigate back to Manage Stock screen (2 levels back)
            if let navigationController = self?.navigationController {
                let viewControllers = navigationController.viewControllers
                if viewControllers.count >= 3 {
                    // Go back 2 screens to Manage Stock
                    navigationController.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                }
            }
        }
        
        alert.addAction(closeAction)
        present(alert, animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func homeButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func notificationsButtonTapped() {
        print("Notifications tapped")
    }
    
    @objc private func profileButtonTapped() {
        print("Profile tapped")
    }
    
    @objc private func settingsButtonTapped() {
        print("Settings tapped")
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
    
    private func dynamicTabBarBackgroundColor() -> UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? .systemGray6 : .white
        }
    }
}

// MARK: - Custom Tab Bar Button

class TabBarButton: UIButton {
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let tabTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconName: String
    private let buttonTitle: String
    private var isTabSelected: Bool
    
    init(icon: String, title: String, isSelected: Bool) {
        self.iconName = icon
        self.buttonTitle = title
        self.isTabSelected = isSelected
        super.init(frame: .zero)
        setupUI()
        updateAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(iconImageView)
        addSubview(tabTitleLabel)
        
        tabTitleLabel.text = buttonTitle
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            tabTitleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 4),
            tabTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func setSelected(_ isSelected: Bool) {
        isTabSelected = isSelected
        updateAppearance()
    }
    
    private func updateAppearance() {
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        let imageName = isTabSelected ? "\(iconName).fill" : iconName
        iconImageView.image = UIImage(systemName: imageName, withConfiguration: config)
        
        let color: UIColor = isTabSelected ? .systemGray : .systemGray3
        iconImageView.tintColor = color
        tabTitleLabel.textColor = color
    }
}
