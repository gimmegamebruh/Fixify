import UIKit

final class UpdateQuantitiesViewController: UIViewController {
    
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
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Please Enter Information for the Items you want to Update :"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let codeLabel: UILabel = {
        let label = UILabel()
        label.text = "Product Code :"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let codeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "1"
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.backgroundColor = UIColor.systemGray6
        textField.layer.cornerRadius = 8
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.text = "New Quantity :"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let quantityTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "10"
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.backgroundColor = UIColor.systemGray6
        textField.layer.cornerRadius = 8
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let updateButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(red: 0.28, green: 0.52, blue: 0.93, alpha: 1.0)
        config.cornerStyle = .medium
        
        var titleAttr = AttributedString("Update Quantity")
        titleAttr.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleAttr.foregroundColor = .white
        config.attributedTitle = titleAttr
        
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 40, bottom: 12, trailing: 40)
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupActions()
        
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
        
        contentView.addSubview(instructionLabel)
        contentView.addSubview(codeLabel)
        contentView.addSubview(codeTextField)
        contentView.addSubview(quantityLabel)
        contentView.addSubview(quantityTextField)
        contentView.addSubview(updateButton)
        
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
            
            instructionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            instructionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            instructionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            codeLabel.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 30),
            codeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            codeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            codeTextField.topAnchor.constraint(equalTo: codeLabel.bottomAnchor, constant: 12),
            codeTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            codeTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            codeTextField.heightAnchor.constraint(equalToConstant: 50),
            
            quantityLabel.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 24),
            quantityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            quantityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            quantityTextField.topAnchor.constraint(equalTo: quantityLabel.bottomAnchor, constant: 12),
            quantityTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            quantityTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            quantityTextField.heightAnchor.constraint(equalToConstant: 50),
            
            updateButton.topAnchor.constraint(equalTo: quantityTextField.bottomAnchor, constant: 60),
            updateButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            updateButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
        
        // Apply dynamic colors
        instructionLabel.textColor = dynamicTextColor()
        codeLabel.textColor = dynamicTextColor()
        quantityLabel.textColor = dynamicTextColor()
        codeTextField.textColor = dynamicTextColor()
        quantityTextField.textColor = dynamicTextColor()
    }
    
    private func setupActions() {
        updateButton.addTarget(self, action: #selector(updateQuantityTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func updateQuantityTapped() {
        // Validate inputs
        guard let code = codeTextField.text, !code.isEmpty else {
            showAlert(message: "Please enter the product code")
            return
        }
        
        guard let quantityText = quantityTextField.text, !quantityText.isEmpty,
              let quantity = Int(quantityText), quantity > 0 else {
            showAlert(message: "Please enter a valid quantity")
            return
        }
        
        // Show success popup
        showSuccessPopup()
    }
    
    private func showSuccessPopup() {
        let alert = UIAlertController(title: "Quantity Updated", message: nil, preferredStyle: .alert)
        
        let closeAction = UIAlertAction(title: "Close", style: .default) { [weak self] _ in
            // Navigate back to Inventory Management (root)
            self?.navigationController?.popToRootViewController(animated: true)
        }
        
        alert.addAction(closeAction)
        present(alert, animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
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
