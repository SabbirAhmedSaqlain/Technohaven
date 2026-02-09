//
//  MainCoordinator.swift
//  TestExam
//
//  Created by Sabbir on 2/8/26.
//

import UIKit

final class MainCoordinator: Coordinator {
    let navigationController: UINavigationController
    private let container: AppDIContainer

    var onLogout: (() -> Void)?

    init(navigationController: UINavigationController, container: AppDIContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        let home = container.makeHomeVC()

        home.onShowTransactions = { [weak self] in
            guard let self else { return }
            let vc = self.container.makeTransactionHistoryVC()
            self.navigationController.pushViewController(vc, animated: true)
        }

        home.onShowSendFunds = { [weak self] in
            guard let self else { return }
            let vc = self.container.makeSendFundsVC()
            vc.onTransferCompleted = { [weak home] in
                home?.refresh()
            }
            self.navigationController.pushViewController(vc, animated: true)
        }

        home.onLogout = { [weak self] in
            self?.container.transactionStore.logout()
            self?.onLogout?()
        }

        navigationController.setViewControllers([home], animated: true)
    }
}
