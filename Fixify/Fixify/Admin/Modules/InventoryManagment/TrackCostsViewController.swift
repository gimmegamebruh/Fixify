import UIKit
import FirebaseFirestore

final class TrackCostsViewController: UIViewController {
    
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
        label.text = "Please Enter the Code for the Stock you want to Access"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let codeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter product code"
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
    
    private let lookupButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(red: 0.28, green: 0.52, blue: 0.93, alpha: 1.0)
        config.cornerStyle = .medium
        
        var titleAttr = AttributedString("Lookup Item")
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
        
        contentView.addSubview(instructionLabel)
        contentView.addSubview(codeTextField)
        contentView.addSubview(lookupButton)
        
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
            
            lookupButton.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 60),
            lookupButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            lookupButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
        
        // Apply dynamic colors
        instructionLabel.textColor = dynamicTextColor()
        codeTextField.textColor = dynamicTextColor()
    }
    
    private func setupActions() {
        lookupButton.addTarget(self, action: #selector(lookupItemTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func lookupItemTapped() {
        // Validate input
        guard let code = codeTextField.text, !code.isEmpty else {
            showAlert(message: "Please enter the product code")
            return
        }
        
        // Show loading
        lookupButton.isEnabled = false
        lookupButton.configuration?.showsActivityIndicator = true
        
        // Check if product exists in Firebase
        ProductService.shared.fetchProduct(byProductId: code) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.lookupButton.isEnabled = true
                self.lookupButton.configuration?.showsActivityIndicator = false
                
                switch result {
                case .success(let product):
                    if product != nil {
                        // Product found, navigate to cost details screen
                        let costDetailsVC = CostDetailsViewController(productCode: code)
                        self.navigationController?.pushViewController(costDetailsVC, animated: true)
                    } else {
                        // Product not found
                        self.showAlert(message: "Product with code '\(code)' not found. Please check the code and try again.")
                    }
                    
                case .failure(let error):
                    print("Error looking up product: \(error.localizedDescription)")
                    self.showAlert(message: "Failed to lookup product. Please try again.")
                }
            }
        }
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
