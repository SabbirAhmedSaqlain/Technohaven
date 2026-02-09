//
//  SendTabCoordinator.swift
//  TestExam
//
//  Created by Sabbir on 2/8/26.
//

import UIKit

final class SendTabCoordinator: Coordinator {
    let navigationController: UINavigationController
    private let container: AppDIContainer

    var onTransferCompleted: (() -> Void)?

    init(navigationController: UINavigationController, container: AppDIContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        let vc = container.makeSendFundsVC()
        vc.tabBarItem = UITabBarItem(title: "Send", image: UIImage(systemName: "paperplane"), tag: 2)

        // Keep your existing completion callback
        vc.onTransferCompleted = { [weak self] in
            self?.onTransferCompleted?()
        }

        navigationController.setViewControllers([vc], animated: false)
    }
}

