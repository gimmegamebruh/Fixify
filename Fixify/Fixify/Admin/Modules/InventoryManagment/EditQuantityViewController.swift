import UIKit
import FirebaseFirestore

final class EditQuantityViewController: UIViewController {
    
    private let productCode: String
    private var product: Product?
    private var newQuantity: Int = 0
    
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
        label.text = "Loading..."
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let codeLabel: UILabel = {
        let label = UILabel()
        label.text = "Code : --"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let currentQuantityValueLabel: UILabel = {
        let label = UILabel()
        label.text = "--"
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
        textField.text = "0"
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
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
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
        loadProduct()
        
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
        view.addSubview(activityIndicator)
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
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Apply dynamic colors
        itemNameLabel.textColor = dynamicTextColor()
        quantityTextField.textColor = dynamicTextColor()
        currentQuantityValueLabel.textColor = dynamicTextColor()
        updateLabel.textColor = dynamicTextColor()
    }
    
    private func setupActions() {
        decreaseButton.addTarget(self, action: #selector(decreaseQuantity), for: .touchUpInside)
        increaseButton.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        quantityTextField.addTarget(self, action: #selector(quantityTextChanged), for: .editingChanged)
    }
    
    // MARK: - Firebase Integration
    
    private func loadProduct() {
        activityIndicator.startAnimating()
        
        ProductService.shared.fetchProduct(byProductId: productCode) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                
                switch result {
                case .success(let product):
                    if let product = product {
                        self.product = product
                        self.newQuantity = product.quantity
                        self.updateUI(with: product)
                    } else {
                        self.showAlert(message: "Product not found", shouldPopBack: true)
                    }
                    
                case .failure(let error):
                    print("Error loading product: \(error.localizedDescription)")
                    self.showAlert(message: "Failed to load product", shouldPopBack: true)
                }
            }
        }
    }
    
    private func updateUI(with product: Product) {
        itemNameLabel.text = product.name
        codeLabel.text = "Code : \(product.id)"
        currentQuantityValueLabel.text = "\(product.quantity)"
        quantityTextField.text = "\(product.quantity)"
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
            newQuantity = max(0, value)
        }
    }
    
    @objc private func confirmTapped() {
        guard let product = product else { return }
        
        confirmButton.isEnabled = false
        confirmButton.configuration?.showsActivityIndicator = true
        
        ProductService.shared.updateQuantity(productId: product.id, newQuantity: newQuantity) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.confirmButton.isEnabled = true
                self.confirmButton.configuration?.showsActivityIndicator = false
                
                switch result {
                case .success:
                    self.showSuccessPopup()
                    
                case .failure(let error):
                    print("Error updating quantity: \(error.localizedDescription)")
                    self.showAlert(message: "Failed to update quantity. Please try again.", shouldPopBack: false)
                }
            }
        }
    }
    
    private func showSuccessPopup() {
        let alert = UIAlertController(title: "Updates Made", message: nil, preferredStyle: .alert)
        
        let closeAction = UIAlertAction(title: "Close", style: .default) { [weak self] _ in
            // Navigate back to Manage Stock screen (2 levels back)
            if let navigationController = self?.navigationController {
                let viewControllers = navigationController.viewControllers
                if viewControllers.count >= 3 {
                    navigationController.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                }
            }
        }
        
        alert.addAction(closeAction)
        present(alert, animated: true)
    }
    
    private func showAlert(message: String, shouldPopBack: Bool) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            if shouldPopBack {
                self?.navigationController?.popViewController(animated: true)
            }
        })
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
