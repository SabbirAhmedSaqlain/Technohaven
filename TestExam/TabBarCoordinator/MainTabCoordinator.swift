//
//  MainTabCoordinator.swift
//  TestExam
//
//  Created by Sabbir on 2/8/26.
//


import UIKit

final class MainTabCoordinator: Coordinator {
    let navigationController: UINavigationController
    private let container: AppDIContainer

    var onLogout: (() -> Void)?

    // Child coordinators (one per tab)
    private var homeCoordinator: HomeTabCoordinator?
    private var transactionsCoordinator: TransactionsTabCoordinator?
    private var sendCoordinator: SendTabCoordinator?

    init(navigationController: UINavigationController, container: AppDIContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        let tabBar = TabBarController()

        // Each tab gets its own UINavigationController
        let homeNav = UINavigationController()
        let txNav = UINavigationController()
        let sendNav = UINavigationController()

        // Create coordinators for each tab
        let home = HomeTabCoordinator(navigationController: homeNav, container: container)
        home.onLogout = { [weak self] in
            self?.container.transactionStore.logout()
            self?.onLogout?()
        }
        home.onSelectTab = { [weak tabBar] index in
            tabBar?.selectedIndex = index
        }

        let tx = TransactionsTabCoordinator(navigationController: txNav, container: container)

        let send = SendTabCoordinator(navigationController: sendNav, container: container)
        send.onTransferCompleted = { [weak home] in
            home?.refreshHomeIfVisible()
        }

        homeCoordinator = home
        transactionsCoordinator = tx
        sendCoordinator = send

        home.start()
        tx.start()
        send.start()

        tabBar.setViewControllers([homeNav, txNav, sendNav], animated: false)

        navigationController.setViewControllers([tabBar], animated: true)
    }
}

