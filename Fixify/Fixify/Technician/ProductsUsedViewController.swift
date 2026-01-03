import UIKit
import FirebaseFirestore

final class ProductsUsedViewController: UIViewController {
    
    private let requestId: String
    private var productsToDeduct: [(productId: String, name: String, quantity: Int)] = []
    private let db = Firestore.firestore()
    var onJobCompleted: (() -> Void)?
    
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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Products Used in Repair"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Add products used to update inventory"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let addProductButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(red: 0.28, green: 0.52, blue: 0.93, alpha: 1.0)
        config.cornerStyle = .medium
        
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        config.image = UIImage(systemName: "plus.circle.fill", withConfiguration: iconConfig)
        config.imagePlacement = .leading
        config.imagePadding = 8
        
        var titleAttr = AttributedString("Add Product")
        titleAttr.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleAttr.foregroundColor = .white
        config.attributedTitle = titleAttr
        
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let completeButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemGreen
        config.cornerStyle = .medium
        
        var titleAttr = AttributedString("Complete Job")
        titleAttr.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleAttr.foregroundColor = .white
        config.attributedTitle = titleAttr
        
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 40, bottom: 14, trailing: 40)
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip & Complete Without Products", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(requestId: String) {
        self.requestId = requestId
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
    }
    
    private func setupNavigationBar() {
        title = "Products Used"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        view.backgroundColor = .systemBackground
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(instructionLabel)
        contentView.addSubview(productsStackView)
        contentView.addSubview(addProductButton)
        contentView.addSubview(completeButton)
        contentView.addSubview(skipButton)
        
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
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            instructionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            instructionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            instructionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            productsStackView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 30),
            productsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            productsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            addProductButton.topAnchor.constraint(equalTo: productsStackView.bottomAnchor, constant: 20),
            addProductButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            completeButton.topAnchor.constraint(equalTo: addProductButton.bottomAnchor, constant: 30),
            completeButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            skipButton.topAnchor.constraint(equalTo: completeButton.bottomAnchor, constant: 12),
            skipButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            skipButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        displayProducts()
        updateCompleteButtonState()
    }
    
    private func setupActions() {
        addProductButton.addTarget(self, action: #selector(addProductTapped), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(completeJobTapped), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
    }
    
    @objc private func addProductTapped() {
        let selectVC = SelectProductViewController()
        selectVC.onProductSelected = { [weak self] productId, productName in
            self?.showQuantityInput(for: productId, name: productName)
        }
        
        let navController = UINavigationController(rootViewController: selectVC)
        present(navController, animated: true)
    }
    
    private func showQuantityInput(for productId: String, name: String) {
        // First, fetch the product to check available quantity
        ProductService.shared.fetchProduct(byProductId: productId) { [weak self] (result: Result<Product?, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let product):
                guard let product = product else {
                    self.showAlert(message: "Product not found.")
                    return
                }
                let availableQty = product.quantity
                
                let alert = UIAlertController(
                    title: "Quantity Used",
                    message: "How many \(name) were used?\n\nAvailable in stock: \(availableQty)",
                    preferredStyle: .alert
                )
                
                alert.addTextField { textField in
                    textField.placeholder = "Enter quantity (max: \(availableQty))"
                    textField.keyboardType = .numberPad
                }
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                alert.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] _ in
                    guard let self = self,
                          let text = alert.textFields?.first?.text,
                          let quantity = Int(text),
                          quantity > 0 else {
                        self?.showAlert(message: "Please enter a valid quantity")
                        return
                    }
                    
                    if quantity > availableQty {
                        self.showAlert(message: "Cannot use \(quantity) units. Only \(availableQty) available in stock.")
                        return
                    }
                    
                    self.productsToDeduct.append((productId, name, quantity))
                    self.displayProducts()
                    self.updateCompleteButtonState()
                })
                
                self.present(alert, animated: true)
                
            case .failure(let error):
                self.showAlert(message: "Could not fetch product details. Please try again.")
                print("Error fetching product: \(error)")
            }
        }
    }
    
    private func displayProducts() {
        productsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if productsToDeduct.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "No products added yet"
            emptyLabel.textColor = .secondaryLabel
            emptyLabel.textAlignment = .center
            emptyLabel.font = UIFont.systemFont(ofSize: 14)
            productsStackView.addArrangedSubview(emptyLabel)
        } else {
            for (index, product) in productsToDeduct.enumerated() {
                let card = createProductCard(productId: product.productId, name: product.name, quantity: product.quantity, index: index)
                productsStackView.addArrangedSubview(card)
            }
        }
    }
    
    private func createProductCard(productId: String, name: String, quantity: Int, index: Int) -> UIView {
        let card = UIView()
        card.backgroundColor = .secondarySystemBackground
        card.layer.cornerRadius = 12
        card.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let detailsLabel = UILabel()
        detailsLabel.text = "Product ID: \(productId) • Qty Used: \(quantity)"
        detailsLabel.font = UIFont.systemFont(ofSize: 14)
        detailsLabel.textColor = .secondaryLabel
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let removeButton = UIButton(type: .system)
        removeButton.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        removeButton.tintColor = .systemRed
        removeButton.tag = index
        removeButton.addTarget(self, action: #selector(removeProduct(_:)), for: .touchUpInside)
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(nameLabel)
        card.addSubview(detailsLabel)
        card.addSubview(removeButton)
        
        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(greaterThanOrEqualToConstant: 70),
            
            nameLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: removeButton.leadingAnchor, constant: -12),
            
            detailsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            detailsLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            detailsLabel.trailingAnchor.constraint(equalTo: removeButton.leadingAnchor, constant: -12),
            detailsLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12),
            
            removeButton.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            removeButton.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            removeButton.widthAnchor.constraint(equalToConstant: 30),
            removeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        return card
    }
    
    @objc private func removeProduct(_ sender: UIButton) {
        let index = sender.tag
        guard index < productsToDeduct.count else { return }
        
        productsToDeduct.remove(at: index)
        displayProducts()
        updateCompleteButtonState()
    }
    
    private func updateCompleteButtonState() {
        // Complete button is always enabled since skipping is allowed
        completeButton.isEnabled = true
        completeButton.alpha = 1.0
    }
    
    @objc private func completeJobTapped() {
        // If no products added, ask for confirmation
        if productsToDeduct.isEmpty {
            let alert = UIAlertController(
                title: "No Products Added",
                message: "You haven't added any products. Do you want to complete without updating inventory?",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Complete Anyway", style: .default) { [weak self] _ in
                self?.completeJobWithoutProducts()
            })
            
            present(alert, animated: true)
        } else {
            updateInventoryAndComplete()
        }
    }
    
    @objc private func skipTapped() {
        let alert = UIAlertController(
            title: "Skip Products?",
            message: "Are you sure you want to complete this job without updating inventory?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Yes, Complete", style: .default) { [weak self] _ in
            self?.completeJobWithoutProducts()
        })
        
        present(alert, animated: true)
    }
    
    private func updateInventoryAndComplete() {
        // Show loading
        let loadingAlert = UIAlertController(title: nil, message: "Updating inventory...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.startAnimating()
        loadingAlert.view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: loadingAlert.view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: loadingAlert.view.centerYAnchor, constant: -10)
        ])
        present(loadingAlert, animated: true)
        
        // Update each product quantity in Firebase
        let dispatchGroup = DispatchGroup()
        var hasError = false
        
        for product in productsToDeduct {
            dispatchGroup.enter()
            
            ProductService.shared.fetchProduct(byProductId: product.productId) { (result: Result<Product?, Error>) in
                defer { dispatchGroup.leave() }
                
                switch result {
                case .success(let fetchedProduct):
                    guard let fetchedProduct = fetchedProduct else {
                        hasError = true
                        return
                    }
                    let newQuantity = max(0, fetchedProduct.quantity - product.quantity)
                    
                    ProductService.shared.updateQuantity(productId: product.productId, newQuantity: newQuantity) { (updateResult: Result<String, Error>) in
                        if case .failure = updateResult {
                            hasError = true
                        }
                    }
                    
                case .failure:
                    hasError = true
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            loadingAlert.dismiss(animated: true) {
                if hasError {
                    self?.showAlert(message: "Some products could not be updated. Please check inventory manually.")
                } else {
                    self?.showSuccessAndDismiss()
                }
            }
        }
    }
    
    private func completeJobWithoutProducts() {
        showSuccessAndDismiss()
    }
    
    private func showSuccessAndDismiss() {
        // Call the completion handler to update status BEFORE showing alert
        onJobCompleted?()
        
        let alert = UIAlertController(
            title: "Job Completed",
            message: "The repair job has been marked as completed and inventory updated.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        
        present(alert, animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Select Product View Controller

final class SelectProductViewController: UIViewController {
    
    var onProductSelected: ((String, String) -> Void)?
    private var products: [Product] = []
    
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private var filteredProducts: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Product"
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        
        setupUI()
        loadProducts()
    }
    
    private func setupUI() {
        searchBar.delegate = self
        searchBar.placeholder = "Search products"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadProducts() {
        ProductService.shared.fetchAllProducts { [weak self] result in
            switch result {
            case .success(let products):
                self?.products = products
                self?.filteredProducts = products
                self?.tableView.reloadData()
            case .failure(let error):
                print("Error loading products: \(error)")
            }
        }
    }
    
    @objc private func dismissView() {
        dismiss(animated: true)
    }
}

extension SelectProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let product = filteredProducts[indexPath.row]
        
        var config = cell.defaultContentConfiguration()
        config.text = product.name
        config.secondaryText = "ID: \(product.id) • Available: \(product.quantity)"
        cell.contentConfiguration = config
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let product = filteredProducts[indexPath.row]
        
        dismiss(animated: true) { [weak self] in
            self?.onProductSelected?(product.id, product.name)
        }
    }
}

extension SelectProductViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredProducts = products
        } else {
            filteredProducts = products.filter { product in
                product.name.lowercased().contains(searchText.lowercased()) ||
                product.id.contains(searchText)
            }
        }
        tableView.reloadData()
    }
}
