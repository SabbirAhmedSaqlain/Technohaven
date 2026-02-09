//
//  AppDIContainer.swift
//  TestExam
//
//  Created by Sabbir on 2/8/26.
//

import Foundation
import UIKit

final class AppDIContainer {
    // Persistence
    private let sessionStore = InMemorySessionStore()

    // Services
    lazy var authService: AuthServicing = AuthService(session: sessionStore)
    private lazy var txLoader: TransactionLoading = MockTransactionLoader()
    lazy var transactionStore: TransactionStoring = TransactionStore(session: sessionStore, loader: txLoader)

    // ViewModel factories
    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(authService: authService)
    }

    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(store: transactionStore)
    }

    func makeTransactionHistoryViewModel() -> TransactionHistoryViewModel {
        TransactionHistoryViewModel(store: transactionStore)
    }

    func makeSendFundsViewModel() -> SendFundsViewModel {
        SendFundsViewModel(store: transactionStore)
    }

    // VC factories
    func makeLoginVC() -> LoginViewController {
        LoginViewController(viewModel: makeLoginViewModel())
    }

    func makeHomeVC() -> HomeViewController {
        HomeViewController(viewModel: makeHomeViewModel())
    }

    func makeTransactionHistoryVC() -> TransactionHistoryViewController {
        TransactionHistoryViewController(viewModel: makeTransactionHistoryViewModel())
    }

    func makeSendFundsVC() -> SendFundsViewController {
        SendFundsViewController(viewModel: makeSendFundsViewModel())
    }
}
