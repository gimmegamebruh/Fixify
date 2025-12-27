import UIKit

final class CostDetailsViewController: UIViewController {
    
    private let productCode: String
    private var currentPrice: Double = 10.0
    private var newPrice: Double = 5.0
    
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
    
    private let currentPriceValueLabel: UILabel = {
        let label = UILabel()
        label.text = "10"
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let currentPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "Current Price"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceControlsContainer: UIView = {
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
    
    private let priceTextField: UITextField = {
        let textField = UITextField()
        textField.text = "5"
        textField.font = UIFont.systemFont(ofSize: 36, weight: .semibold)
        textField.textAlignment = .center
        textField.keyboardType = .decimalPad
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
        updatePriceDisplay()
        
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
        titleLabel.text = "Track Costs"
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
        contentView.addSubview(currentPriceValueLabel)
        contentView.addSubview(currentPriceLabel)
        contentView.addSubview(priceControlsContainer)
        contentView.addSubview(confirmButton)
        
        priceControlsContainer.addSubview(decreaseButton)
        priceControlsContainer.addSubview(priceTextField)
        priceControlsContainer.addSubview(increaseButton)
        priceControlsContainer.addSubview(updateLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
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
            
            currentPriceValueLabel.topAnchor.constraint(equalTo: codeLabel.bottomAnchor, constant: 80),
            currentPriceValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            
            currentPriceLabel.topAnchor.constraint(equalTo: currentPriceValueLabel.bottomAnchor, constant: 8),
            currentPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            
            priceControlsContainer.topAnchor.constraint(equalTo: currentPriceLabel.bottomAnchor, constant: 60),
            priceControlsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            priceControlsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            priceControlsContainer.heightAnchor.constraint(equalToConstant: 80),
            
            decreaseButton.leadingAnchor.constraint(equalTo: priceControlsContainer.leadingAnchor),
            decreaseButton.centerYAnchor.constraint(equalTo: priceTextField.centerYAnchor),
            decreaseButton.widthAnchor.constraint(equalToConstant: 50),
            decreaseButton.heightAnchor.constraint(equalToConstant: 50),
            
            priceTextField.centerXAnchor.constraint(equalTo: priceControlsContainer.centerXAnchor, constant: -30),
            priceTextField.topAnchor.constraint(equalTo: priceControlsContainer.topAnchor),
            priceTextField.widthAnchor.constraint(equalToConstant: 100),
            
            increaseButton.leadingAnchor.constraint(equalTo: priceTextField.trailingAnchor, constant: 20),
            increaseButton.centerYAnchor.constraint(equalTo: priceTextField.centerYAnchor),
            increaseButton.widthAnchor.constraint(equalToConstant: 50),
            increaseButton.heightAnchor.constraint(equalToConstant: 50),
            
            updateLabel.leadingAnchor.constraint(equalTo: increaseButton.trailingAnchor, constant: 20),
            updateLabel.centerYAnchor.constraint(equalTo: priceTextField.centerYAnchor),
            updateLabel.trailingAnchor.constraint(equalTo: priceControlsContainer.trailingAnchor),
            
            confirmButton.topAnchor.constraint(equalTo: priceControlsContainer.bottomAnchor, constant: 80),
            confirmButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
        
        // Apply dynamic colors
        itemNameLabel.textColor = dynamicTextColor()
        priceTextField.textColor = dynamicTextColor()
        currentPriceValueLabel.textColor = dynamicTextColor()
        updateLabel.textColor = dynamicTextColor()
    }
    
    private func setupActions() {
        decreaseButton.addTarget(self, action: #selector(decreasePrice), for: .touchUpInside)
        increaseButton.addTarget(self, action: #selector(increasePrice), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        priceTextField.addTarget(self, action: #selector(priceTextChanged), for: .editingChanged)
    }
    
    private func updatePriceDisplay() {
        priceTextField.text = String(format: "%.1f", newPrice)
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func decreasePrice() {
        if newPrice > 0 {
            newPrice -= 0.5
            updatePriceDisplay()
        }
    }
    
    @objc private func increasePrice() {
        newPrice += 0.5
        updatePriceDisplay()
    }
    
    @objc private func priceTextChanged() {
        if let text = priceTextField.text, let value = Double(text) {
            newPrice = value
        }
    }
    
    @objc private func confirmTapped() {
        // Show success popup
        showSuccessPopup()
    }
    
    private func showSuccessPopup() {
        let alert = UIAlertController(title: "Cost Changed", message: nil, preferredStyle: .alert)
        
        let closeAction = UIAlertAction(title: "Close", style: .default) { [weak self] _ in
            // Navigate back to Inventory Management (root)
            self?.navigationController?.popToRootViewController(animated: true)
        }
        
        alert.addAction(closeAction)
        present(alert, animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
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
