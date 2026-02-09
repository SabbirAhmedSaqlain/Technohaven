import UIKit

final class HomeViewController: UIViewController {
    private let viewModel: HomeViewModel

    var onShowTransactions: (() -> Void)?
    var onShowSendFunds: (() -> Void)?
    var onLogout: (() -> Void)?

    private let headerLabel = UILabel()
    private let infoCard = UIView()

    private let nameTitle = UILabel()
    private let nameValue = UILabel()
    private let acctTitle = UILabel()
    private let acctValue = UILabel()

    private let balanceCard = UIView()
    private let balanceTitle = UILabel()
    private let balanceValue = UILabel()

    private let primaryStack = UIStackView()
    private let txButton = UIButton(type: .system)
    private let sendButton = UIButton(type: .system)
    private let logoutButton = UIButton(type: .system)

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Home"
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationItem.largeTitleDisplayMode = .always
        setupUI()
        refresh()
    }

    func refresh() {
        switch viewModel.load() {
        case .success(let user):
            headerLabel.text = "Hi, \(user.fullName)"
            nameValue.text = user.fullName
            acctValue.text = user.accountId
            balanceValue.text = viewModel.balanceText()
        case .failure(let err):
            AlertPresenter.showOk(on: self, title: "Error", message: err.localizedDescription)
        }
    }

    private func setupUI() {
        // Top right logout
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(didTapLogout)
        )

        headerLabel.font = .systemFont(ofSize: 26, weight: .bold)
        headerLabel.numberOfLines = 0

        styleCard(infoCard)
        styleCard(balanceCard)

        nameTitle.text = "Full name"
        acctTitle.text = "Account ID"
        [nameTitle, acctTitle].forEach {
            $0.font = .systemFont(ofSize: 13, weight: .semibold)
            $0.textColor = .secondaryLabel
        }

        [nameValue, acctValue].forEach {
            $0.font = .systemFont(ofSize: 17, weight: .medium)
            $0.numberOfLines = 0
        }

        let row1 = makeInfoRow(title: nameTitle, value: nameValue, icon: "person.fill")
        let row2 = makeInfoRow(title: acctTitle, value: acctValue, icon: "number")

        let infoStack = UIStackView(arrangedSubviews: [row1, divider(), row2])
        infoStack.axis = .vertical
        infoStack.spacing = 12

        infoCard.addSubview(infoStack)
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoStack.leadingAnchor.constraint(equalTo: infoCard.leadingAnchor, constant: 16),
            infoStack.trailingAnchor.constraint(equalTo: infoCard.trailingAnchor, constant: -16),
            infoStack.topAnchor.constraint(equalTo: infoCard.topAnchor, constant: 16),
            infoStack.bottomAnchor.constraint(equalTo: infoCard.bottomAnchor, constant: -16)
        ])

        balanceTitle.text = "Available balance"
        balanceTitle.font = .systemFont(ofSize: 14, weight: .semibold)
        balanceTitle.textColor = .secondaryLabel

        balanceValue.font = .systemFont(ofSize: 34, weight: .bold)
        balanceValue.adjustsFontSizeToFitWidth = true
        balanceValue.minimumScaleFactor = 0.7

        let balanceIcon = UIImageView(image: UIImage(systemName: "creditcard.fill"))
        balanceIcon.tintColor = .systemBlue
        balanceIcon.setContentHuggingPriority(.required, for: .horizontal)

        let balanceTop = UIStackView(arrangedSubviews: [balanceIcon, balanceTitle, UIView()])
        balanceTop.axis = .horizontal
        balanceTop.alignment = .center
        balanceTop.spacing = 10

        let balanceStack = UIStackView(arrangedSubviews: [balanceTop, balanceValue])
        balanceStack.axis = .vertical
        balanceStack.spacing = 8

        balanceCard.addSubview(balanceStack)
        balanceStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            balanceStack.leadingAnchor.constraint(equalTo: balanceCard.leadingAnchor, constant: 16),
            balanceStack.trailingAnchor.constraint(equalTo: balanceCard.trailingAnchor, constant: -16),
            balanceStack.topAnchor.constraint(equalTo: balanceCard.topAnchor, constant: 16),
            balanceStack.bottomAnchor.constraint(equalTo: balanceCard.bottomAnchor, constant: -16)
        ])

        configurePrimaryButton(txButton, title: "Transaction History", systemImage: "list.bullet")
        configurePrimaryButton(sendButton, title: "Send Funds", systemImage: "paperplane.fill")
        configureSecondaryButton(logoutButton, title: "Logout")

        txButton.addTarget(self, action: #selector(didTapTx), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(didTapSend), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)

        let actions = UIStackView(arrangedSubviews: [txButton, sendButton])
        actions.axis = .vertical
        actions.spacing = 12

        primaryStack.axis = .vertical
        primaryStack.spacing = 14
        primaryStack.translatesAutoresizingMaskIntoConstraints = false
        primaryStack.addArrangedSubview(headerLabel)
        primaryStack.addArrangedSubview(infoCard)
        primaryStack.addArrangedSubview(balanceCard)
        primaryStack.addArrangedSubview(actions)

        view.addSubview(primaryStack)

        NSLayoutConstraint.activate([
            primaryStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            primaryStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            primaryStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
    }

    @objc private func didTapTx() { onShowTransactions?() }
    @objc private func didTapSend() { onShowSendFunds?() }
    @objc private func didTapLogout() { onLogout?() }

    private func configurePrimaryButton(_ b: UIButton, title: String, systemImage: String) {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.image = UIImage(systemName: systemImage)
        config.imagePadding = 10
        config.cornerStyle = .large
        b.configuration = config
        b.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    private func configureSecondaryButton(_ b: UIButton, title: String) {
        var config = UIButton.Configuration.tinted()
        config.title = title
        config.cornerStyle = .large
        b.configuration = config
        b.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }

    private func styleCard(_ v: UIView) {
        v.backgroundColor = .systemBackground
        v.layer.cornerRadius = 16
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.06
        v.layer.shadowRadius = 14
        v.layer.shadowOffset = CGSize(width: 0, height: 8)
    }

    private func makeInfoRow(title: UILabel, value: UILabel, icon: String) -> UIView {
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .systemBlue
        iconView.contentMode = .scaleAspectFit
        iconView.widthAnchor.constraint(equalToConstant: 22).isActive = true

        let textStack = UIStackView(arrangedSubviews: [title, value])
        textStack.axis = .vertical
        textStack.spacing = 3

        let row = UIStackView(arrangedSubviews: [iconView, textStack])
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 12
        return row
    }

    private func divider() -> UIView {
        let v = UIView()
        v.backgroundColor = .separator
        v.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true
        return v
    }
}
