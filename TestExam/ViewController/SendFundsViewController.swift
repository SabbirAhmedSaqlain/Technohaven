import UIKit

final class SendFundsViewController: UIViewController {
    private let viewModel: SendFundsViewModel

    var onTransferCompleted: (() -> Void)?

    private let cardView = UIView()
    private let receiverField = UITextField()
    private let amountField = UITextField()
    private let sendButton = UIButton(type: .system)

    private let helperLabel = UILabel()

    init(viewModel: SendFundsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Send Funds"
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationItem.largeTitleDisplayMode = .always
        setupUI()
        setupKeyboardDismiss()
    }

    private func setupUI() {
        styleCard(cardView)

        configureTextField(receiverField, placeholder: "Receiver ID", keyboard: .default)
        receiverField.autocapitalizationType = .none
        receiverField.autocorrectionType = .no
        receiverField.returnKeyType = .next

        configureTextField(amountField, placeholder: "Amount", keyboard: .decimalPad)

        helperLabel.text = "Transfers are recorded as a new transaction and your balance updates immediately."
        helperLabel.font = .systemFont(ofSize: 13, weight: .regular)
        helperLabel.textColor = .secondaryLabel
        helperLabel.numberOfLines = 0

        var cfg = UIButton.Configuration.filled()
        cfg.title = "Send"
        cfg.image = UIImage(systemName: "paperplane.fill")
        cfg.imagePadding = 10
        cfg.cornerStyle = .large
        sendButton.configuration = cfg
        sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.addTarget(self, action: #selector(didTapSend), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [receiverField, amountField, helperLabel, sendButton])
        stack.axis = .vertical
        stack.spacing = 12

        cardView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])

        cardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])

        receiverField.addTarget(self, action: #selector(receiverReturn), for: .editingDidEndOnExit)
    }

    @objc private func receiverReturn() {
        amountField.becomeFirstResponder()
    }

    @objc private func didTapSend() {
        view.endEditing(true)

        switch viewModel.send(receiverId: receiverField.text ?? "", amountText: amountField.text ?? "") {
        case .success(let message):
            AlertPresenter.showOk(on: self, title: "Success", message: message)
            onTransferCompleted?()
            navigationController?.popViewController(animated: true)
        case .failure(let err):
            AlertPresenter.showOk(on: self, title: "Cannot Send", message: err.localizedDescription)
        }
    }

    private func configureTextField(_ tf: UITextField, placeholder: String, keyboard: UIKeyboardType) {
        tf.placeholder = placeholder
        tf.keyboardType = keyboard
        tf.borderStyle = .none
        tf.backgroundColor = .secondarySystemGroupedBackground
        tf.layer.cornerRadius = 12
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.separator.cgColor
        tf.heightAnchor.constraint(equalToConstant: 48).isActive = true

        let pad = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 48))
        tf.leftView = pad
        tf.leftViewMode = .always
    }

    private func styleCard(_ v: UIView) {
        v.backgroundColor = .systemBackground
        v.layer.cornerRadius = 16
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.06
        v.layer.shadowRadius = 14
        v.layer.shadowOffset = CGSize(width: 0, height: 8)
    }

    private func setupKeyboardDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func endEditing() {
        view.endEditing(true)
    }
}
