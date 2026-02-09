//
//  HomeViewModel.swift
//  TestExam
//
//  Created by Sabbir on 2/8/26.
//

import Foundation

final class HomeViewModel {
    private let store: TransactionStoring

    init(store: TransactionStoring) {
        self.store = store
    }

    func load() -> Result<User, AppError> {
        guard let user = store.user else {
            return .failure(.unknown("No user session."))
        }
        return .success(user)
    }

    func balanceText() -> String {
        let bal = NSDecimalNumber(decimal: store.currentBalance()).doubleValue
        return String(format: "$%.2f", bal)
    }
}
