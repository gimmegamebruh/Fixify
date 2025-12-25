//
//  ChatViewController.swift
//  Fixify
//
//  Created by BP-36-213-15 on 25/12/2025.
//


import UIKit

final class ChatViewController: UIViewController {

    private let requestID: String
    private var messages: [ChatMessage] = []

    private let tableView = UITableView()
    private let inputField = UITextField()
    private let sendButton = UIButton(type: .system)

    init(requestID: String) {
        self.requestID = requestID
        super.init(nibName: nil, bundle: nil)
        title = "Chat"
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        listen()
    }

    private func setupUI() {
        tableView.register(ChatBubbleCell.self, forCellReuseIdentifier: ChatBubbleCell.reuseID)
        tableView.dataSource = self
        tableView.separatorStyle = .none

        inputField.placeholder = "Message..."
        inputField.borderStyle = .roundedRect

        sendButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)

        let inputStack = UIStackView(arrangedSubviews: [inputField, sendButton])
        inputStack.spacing = 8

        tableView.translatesAutoresizingMaskIntoConstraints = false
        inputStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        view.addSubview(inputStack)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputStack.topAnchor),

            inputStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            inputStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            inputStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }

    private func listen() {
        ChatService.shared.listen(requestID: requestID) { [weak self] msgs in
            self?.messages = msgs
            self?.tableView.reloadData()
        }
    }

    @objc private func sendTapped() {
        guard let text = inputField.text, !text.isEmpty else { return }
        ChatService.shared.send(requestID: requestID, text: text)
        inputField.text = nil
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        messages.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatBubbleCell.reuseID,
            for: indexPath
        ) as! ChatBubbleCell

        cell.configure(with: messages[indexPath.row])
        return cell
    }
}
