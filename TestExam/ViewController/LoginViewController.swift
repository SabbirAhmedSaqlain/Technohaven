import UIKit
import LocalAuthentication

final class LoginViewController: UIViewController {
    private let viewModel: LoginViewModel

    private let persistedEmailKey = "persisted_user_email"

    private func persistEmail(_ email: String) {
        UserDefaults.standard.set(email, forKey: persistedEmailKey)
    }

    var onLoginSuccess: (() -> Void)?

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    private let cardView = UIView()
    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let faceIdButton = UIButton(type: .system)
    private let hintLabel = UILabel()

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Login"
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setupUI()
        setupKeyboardDismiss()
        updateBiometricButtonVisibility()
    }

    private func setupUI() {
        navigationItem.largeTitleDisplayMode = .always

        titleLabel.text = "Welcome back"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.numberOfLines = 0

        subtitleLabel.text = "Sign in to view your balance, transactions, and send funds."
        subtitleLabel.font = .systemFont(ofSize: 15, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0

        styleCard(cardView)

        configureTextField(emailField, placeholder: "Email", keyboard: .emailAddress, contentType: .username)
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.returnKeyType = .next

        configureTextField(passwordField, placeholder: "Password", keyboard: .default, contentType: .password)
        passwordField.isSecureTextEntry = true
        passwordField.returnKeyType = .done

        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        loginButton.backgroundColor = .systemBlue
        loginButton.tintColor = .white
        loginButton.layer.cornerRadius = 12
        loginButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)

        // Face ID (minimal add)
        faceIdButton.setTitle("Login with Face ID", for: .normal)
        faceIdButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        faceIdButton.backgroundColor = .secondarySystemBackground
        faceIdButton.tintColor = .label
        faceIdButton.layer.cornerRadius = 12
        faceIdButton.layer.borderWidth = 1
        faceIdButton.layer.borderColor = UIColor.separator.cgColor
        faceIdButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        faceIdButton.setImage(UIImage(systemName: "faceid"), for: .normal)
        faceIdButton.imageView?.contentMode = .scaleAspectFit
        faceIdButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 0)
        faceIdButton.addTarget(self, action: #selector(didTapFaceID), for: .touchUpInside)

        hintLabel.text = "Demo: test@app.com  |  123456"
        hintLabel.font = .systemFont(ofSize: 13, weight: .regular)
        hintLabel.textColor = .secondaryLabel
        hintLabel.textAlignment = .center

        let fieldsStack = UIStackView(arrangedSubviews: [emailField, passwordField, loginButton, faceIdButton, hintLabel])
        fieldsStack.axis = .vertical
        fieldsStack.spacing = 12

        cardView.addSubview(fieldsStack)
        fieldsStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fieldsStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            fieldsStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            fieldsStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            fieldsStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])

        let root = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, cardView])
        root.axis = .vertical
        root.spacing = 14
        root.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(root)
        NSLayoutConstraint.activate([
            root.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            root.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            root.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])

        emailField.addTarget(self, action: #selector(emailReturn), for: .editingDidEndOnExit)
        passwordField.addTarget(self, action: #selector(passwordReturn), for: .editingDidEndOnExit)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Optional: auto-trigger biometrics if available (still "minimal": comment out if undesired)
        // didTapFaceID()
    }

    @objc private func emailReturn() { passwordField.becomeFirstResponder() }
    @objc private func passwordReturn() { didTapLogin() }

    @objc private func didTapLogin() {
        view.endEditing(true)
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""

        switch viewModel.login(email: email, password: password) {
        case .success:
            persistEmail(email)
            onLoginSuccess?()
        case .failure(let err):
            AlertPresenter.showOk(on: self, title: "Login Failed", message: err.localizedDescription)
        }
    }

    // MARK: - Face ID

    private func updateBiometricButtonVisibility() {
        let ctx = LAContext()
        var err: NSError?
        let can = ctx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &err)
        // Show only if biometrics available AND it's Face ID
        faceIdButton.isHidden = !(can && ctx.biometryType == .faceID)
    }

    @objc private func didTapFaceID() {
        view.endEditing(true)

        let ctx = LAContext()
        ctx.localizedCancelTitle = "Cancel"

        var err: NSError?
        guard ctx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &err) else {
            AlertPresenter.showOk(on: self, title: "Face ID Unavailable", message: "Face ID is not available on this device.")
            updateBiometricButtonVisibility()
            return
        }

        guard ctx.biometryType == .faceID else {
            // If you also want Touch ID support, change this guard to allow it
            AlertPresenter.showOk(on: self, title: "Face ID Unavailable", message: "This device does not support Face ID.")
            updateBiometricButtonVisibility()
            return
        }

        ctx.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Sign in with Face ID") { [weak self] success, error in
            guard let self else { return }
            DispatchQueue.main.async {
                if success {
                    // Use mock credentials after successful Face ID auth
                    let result = self.viewModel.login(email: "test@app.com", password: "123456")
                    switch result {
                    case .success:
                        self.persistEmail("test@app.com")
                        self.onLoginSuccess?()
                    case .failure(let err):
                        AlertPresenter.showOk(on: self, title: "Login Failed", message: err.localizedDescription)
                    }
                } else {
                    let msg = (error as NSError?)?.localizedDescription ?? "Authentication failed."
                    AlertPresenter.showOk(on: self, title: "Face ID Failed", message: msg)
                }
            }
        }
    }

    // MARK: - UI Helpers

    private func configureTextField(_ tf: UITextField, placeholder: String, keyboard: UIKeyboardType, contentType: UITextContentType?) {
        tf.placeholder = placeholder
        tf.keyboardType = keyboard
        tf.textContentType = contentType
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
        v.layer.shadowOpacity = 0.07
        v.layer.shadowRadius = 16
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
