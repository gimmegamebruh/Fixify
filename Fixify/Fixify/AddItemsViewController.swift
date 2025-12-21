import UIKit

final class AddItemsViewController: UIViewController {
    
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
        label.text = "Please Enter Information for the Items you want to Add to the System :"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name of the Item(s) :"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Eraser"
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.backgroundColor = UIColor.systemGray6
        textField.layer.cornerRadius = 8
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.text = "Initial Quantity :"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let quantityTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "2"
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
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "Price of the Items (BHD) :"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0.150"
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.backgroundColor = UIColor.systemGray6
        textField.layer.cornerRadius = 8
        textField.keyboardType = .decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let addItemButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(red: 0.28, green: 0.52, blue: 0.93, alpha: 1.0)
        config.cornerStyle = .medium
        
        var titleAttr = AttributedString("Add Item")
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
        titleLabel.text = "Add Items"
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
        contentView.addSubview(nameLabel)
        contentView.addSubview(nameTextField)
        contentView.addSubview(quantityLabel)
        contentView.addSubview(quantityTextField)
        contentView.addSubview(priceLabel)
        contentView.addSubview(priceTextField)
        contentView.addSubview(addItemButton)
        
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
            
            nameLabel.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 30),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            quantityLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            quantityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            quantityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            quantityTextField.topAnchor.constraint(equalTo: quantityLabel.bottomAnchor, constant: 12),
            quantityTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            quantityTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            quantityTextField.heightAnchor.constraint(equalToConstant: 50),
            
            priceLabel.topAnchor.constraint(equalTo: quantityTextField.bottomAnchor, constant: 24),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            priceTextField.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 12),
            priceTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            priceTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            priceTextField.heightAnchor.constraint(equalToConstant: 50),
            
            addItemButton.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: 60),
            addItemButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addItemButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
        
        // Apply dynamic colors
        instructionLabel.textColor = dynamicTextColor()
        nameLabel.textColor = dynamicTextColor()
        quantityLabel.textColor = dynamicTextColor()
        priceLabel.textColor = dynamicTextColor()
        nameTextField.textColor = dynamicTextColor()
        quantityTextField.textColor = dynamicTextColor()
        priceTextField.textColor = dynamicTextColor()
    }
    
    private func setupActions() {
        addItemButton.addTarget(self, action: #selector(addItemTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addItemTapped() {
        // Validate inputs
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(message: "Please enter the item name")
            return
        }
        
        guard let quantityText = quantityTextField.text, !quantityText.isEmpty,
              let quantity = Int(quantityText), quantity > 0 else {
            showAlert(message: "Please enter a valid quantity")
            return
        }
        
        guard let priceText = priceTextField.text, !priceText.isEmpty,
              let price = Double(priceText), price > 0 else {
            showAlert(message: "Please enter a valid price")
            return
        }
        
        // Show success popup
        showSuccessPopup()
    }
    
    private func showSuccessPopup() {
        let alert = UIAlertController(title: "Item Added", message: nil, preferredStyle: .alert)
        
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
