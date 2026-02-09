//
//  HomeTabCoordinator.swift
//  TestExam
//
//  Created by Sabbir on 2/8/26.
//

import UIKit

final class HomeTabCoordinator: Coordinator {
    let navigationController: UINavigationController
    private let container: AppDIContainer

    var onLogout: (() -> Void)?
    var onSelectTab: ((Int) -> Void)?

    private weak var homeVC: HomeViewController?

    init(navigationController: UINavigationController, container: AppDIContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        let vc = container.makeHomeVC()
        homeVC = vc

        vc.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)

        // Minimal change: switch tabs instead of pushing
        vc.onShowTransactions = { [weak self] in self?.onSelectTab?(1) }
        vc.onShowSendFunds = { [weak self] in self?.onSelectTab?(2) }

        vc.onLogout = { [weak self] in
            self?.onLogout?()
        }

        navigationController.setViewControllers([vc], animated: false)
    }

    func refreshHomeIfVisible() {
        homeVC?.refresh()
    }
}
