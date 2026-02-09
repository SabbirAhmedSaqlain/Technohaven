//
//  AppCoordinator.swift
//  TestExam
//
//  Created by Sabbir on 2/8/26.
//

import UIKit
 
final class AppCoordinator: Coordinator {
    let navigationController: UINavigationController
    private let container: AppDIContainer

    private var authCoordinator: AuthCoordinator?
    private var mainTabCoordinator: MainTabCoordinator?

    init(navigationController: UINavigationController, container: AppDIContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        showAuth()
    }

    private func showAuth() {
        let auth = AuthCoordinator(navigationController: navigationController, container: container)
        auth.onAuthed = { [weak self] in
            self?.showMainTabs()
        }
        authCoordinator = auth
        mainTabCoordinator = nil
        auth.start()
    }

    private func showMainTabs() {
        let main = MainTabCoordinator(navigationController: navigationController, container: container)
        main.onLogout = { [weak self] in
            self?.showAuth()
        }
        mainTabCoordinator = main
        authCoordinator = nil
        main.start()
    }
}
