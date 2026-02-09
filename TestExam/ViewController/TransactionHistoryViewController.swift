import UIKit

final class TransactionHistoryViewController: UIViewController {
    private let viewModel: TransactionHistoryViewModel
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let activity = UIActivityIndicatorView(style: .large)

    private let emptyLabel = UILabel()

    init(viewModel: TransactionHistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Transactions"
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationItem.largeTitleDisplayMode = .always
        setupTable()
        setupEmptyState()
        setupLoading()
        load()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load()
    }

    private func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.reuseId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 64

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupEmptyState() {
        emptyLabel.text = ""
        emptyLabel.font = .systemFont(ofSize: 16, weight: .medium)
        emptyLabel.textColor = .secondaryLabel
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0
        tableView.backgroundView = emptyLabel
    }

    private func setupLoading() {
        activity.hidesWhenStopped = true
        activity.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activity)
        NSLayoutConstraint.activate([
            activity.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activity.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func load() {
        activity.startAnimating()
        tableView.isUserInteractionEnabled = false

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            let result = self.viewModel.load()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.activity.stopAnimating()
                self.tableView.isUserInteractionEnabled = true

                switch result {
                case .success:
                    self.emptyLabel.isHidden = !self.viewModel.items.isEmpty
                    self.tableView.reloadData()
                case .failure(let err):
                    AlertPresenter.showOk(on: self, title: "Error", message: err.localizedDescription)
                }
            }
        }
    }
}

extension TransactionHistoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.reuseId, for: indexPath) as? TransactionCell
        else { return UITableViewCell() }

        let tx = viewModel.items[indexPath.row]
        let date = viewModel.formattedDate(for: tx)
        let amount = viewModel.formattedAmount(for: tx)

        cell.configure(
            title: tx.title,
            date: date,
            amount: amount,
            isPositive: tx.amount >= 0
        )
        return cell
    }
}
