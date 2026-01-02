import UIKit
import FirebaseFirestore

final class DeleteItemsViewController: UIViewController {
    
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
        label.text = "Please Enter the Code for the Items you want to Delete"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let codeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "1"
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.backgroundColor = UIColor.systemGray6
        textField.layer.cornerRadius = 8
        textField.keyboardType = .default
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let deleteItemButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemRed
        config.cornerStyle = .medium
        
        var titleAttr = AttributedString("Delete Item")
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
        titleLabel.text = "Delete Items"
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
        contentView.addSubview(codeTextField)
        contentView.addSubview(deleteItemButton)
        
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
            
            codeTextField.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 30),
            codeTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            codeTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            codeTextField.heightAnchor.constraint(equalToConstant: 50),
            
            deleteItemButton.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 60),
            deleteItemButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            deleteItemButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
        
        // Apply dynamic colors
        instructionLabel.textColor = dynamicTextColor()
        codeTextField.textColor = dynamicTextColor()
    }
    
    private func setupActions() {
        deleteItemButton.addTarget(self, action: #selector(deleteItemTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func deleteItemTapped() {
        // Validate input
        guard let code = codeTextField.text, !code.isEmpty else {
            showAlert(message: "Please enter the item code")
            return
        }
        
        // Show confirmation alert
        showConfirmationAlert(for: code)
    }
    
    private func showConfirmationAlert(for productCode: String) {
        let alert = UIAlertController(
            title: "Confirm Deletion",
            message: "Are you sure you want to delete this product? This action cannot be undone.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.performDelete(productCode: productCode)
        })
        
        present(alert, animated: true)
    }
    
    private func performDelete(productCode: String) {
        deleteItemButton.isEnabled = false
        deleteItemButton.configuration?.showsActivityIndicator = true
        
        ProductService.shared.deleteProduct(productId: productCode) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.deleteItemButton.isEnabled = true
                self.deleteItemButton.configuration?.showsActivityIndicator = false
                
                switch result {
                case .success:
                    self.showSuccessPopup()
                    
                case .failure(let error):
                    print("Error deleting product: \(error.localizedDescription)")
                    self.showAlert(message: "Failed to delete product. Please check the code and try again.")
                }
            }
        }
    }
    
    private func showSuccessPopup() {
        let alert = UIAlertController(title: "Item Deleted", message: nil, preferredStyle: .alert)
        
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
