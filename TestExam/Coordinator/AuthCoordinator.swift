//
//  AuthCoordinator.swift
//  TestExam
//
//  Created by Sabbir on 2/8/26.
//
import UIKit

final class AuthCoordinator: Coordinator {
    let navigationController: UINavigationController
    private let container: AppDIContainer

    var onAuthed: (() -> Void)?

    init(navigationController: UINavigationController, container: AppDIContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        let vc = container.makeLoginVC()
        vc.onLoginSuccess = { [weak self] in
            self?.onAuthed?()
        }
        navigationController.setViewControllers([vc], animated: false)
    }
}

