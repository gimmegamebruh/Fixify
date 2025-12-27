import UIKit
import FirebaseFirestore

final class ViewStockViewController: UIViewController {
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.layer.cornerRadius = 10
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.systemGray4.cgColor
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
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
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private var products: [Product] = []
    private var filteredProducts: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredProducts = products
        setupNavigationBar()
        setupUI()
        setupSearchBar()
        loadProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProducts() // Reload when returning to this screen
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
        titleLabel.text = "View Stock"
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
        view.addSubview(searchBar)
        view.addSubview(scrollView)
        view.addSubview(activityIndicator)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            scrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
    }
    
    // MARK: - Firebase Integration
    
    private func loadProducts() {
        activityIndicator.startAnimating()
        
        ProductService.shared.fetchAllProducts { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                
                switch result {
                case .success(let products):
                    self.products = products.sorted { $0.id < $1.id }
                    self.filteredProducts = self.products
                    self.displayProducts()
                    
                case .failure(let error):
                    print("Error loading products: \(error.localizedDescription)")
                    self.showAlert(message: "Failed to load products. Please try again.")
                }
            }
        }
    }
    
    private func displayProducts() {
        // Clear existing views
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if filteredProducts.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = searchBar.text?.isEmpty == false ? "No products found" : "No products available"
            emptyLabel.textAlignment = .center
            emptyLabel.textColor = .systemGray
            emptyLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            stackView.addArrangedSubview(emptyLabel)
            return
        }
        
        // Add product cards
        for product in filteredProducts {
            let productCard = createProductCard(product: product)
            stackView.addArrangedSubview(productCard)
        }
    }
    
    private func createProductCard(product: Product) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = dynamicCardBackgroundColor()
        cardView.layer.cornerRadius = 12
        cardView.layer.borderWidth = 1.5
        cardView.layer.borderColor = UIColor.systemGray4.cgColor
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        // Product Name
        let nameLabel = UILabel()
        nameLabel.text = product.name
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameLabel.textColor = dynamicTextColor()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Product Code
        let codeLabel = UILabel()
        codeLabel.text = "Product Code : \(product.id)"
        codeLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        codeLabel.textColor = dynamicTextColor()
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Price Label
        let priceLabel = UILabel()
        priceLabel.text = "Price :  \(String(format: "%.3f", product.cost)) BHD"
        priceLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        priceLabel.textColor = dynamicTextColor()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Quantity Label
        let quantityLabel = UILabel()
        quantityLabel.text = "Quantity: \(product.quantity)"
        quantityLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        quantityLabel.textColor = dynamicTextColor()
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(nameLabel)
        cardView.addSubview(codeLabel)
        cardView.addSubview(priceLabel)
        cardView.addSubview(quantityLabel)
        
        NSLayoutConstraint.activate([
            cardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 130),
            
            nameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            codeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            codeLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            codeLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            priceLabel.topAnchor.constraint(equalTo: codeLabel.bottomAnchor, constant: 12),
            priceLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            priceLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            
            quantityLabel.topAnchor.constraint(equalTo: codeLabel.bottomAnchor, constant: 12),
            quantityLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            quantityLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
        
        return cardView
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
    
    private func dynamicCardBackgroundColor() -> UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? .systemGray6 : .white
        }
    }
}

// MARK: - UISearchBarDelegate

extension ViewStockViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredProducts = products
        } else {
            // Filter ONLY by product name
            filteredProducts = products.filter { product in
                product.name.lowercased().contains(searchText.lowercased())
            }
        }
        displayProducts()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
