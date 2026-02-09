//
//  TransactionsTabCoordinator.swift
//  TestExam
//
//  Created by Sabbir on 2/8/26.
//

import UIKit

final class TransactionsTabCoordinator: Coordinator {
    let navigationController: UINavigationController
    private let container: AppDIContainer

    init(navigationController: UINavigationController, container: AppDIContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        let vc = container.makeTransactionHistoryVC()
        vc.tabBarItem = UITabBarItem(title: "History", image: UIImage(systemName: "list.bullet"), tag: 1)
        navigationController.setViewControllers([vc], animated: false)
    }
}
