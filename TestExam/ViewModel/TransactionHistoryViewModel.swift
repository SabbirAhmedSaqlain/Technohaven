//
//  TransactionHistoryViewModel.swift
//  TestExam
//
//  Created by Sabbir on 2/8/26.
//

import Foundation

final class TransactionHistoryViewModel {
    private let store: TransactionStoring
    private(set) var items: [Transaction] = []

    init(store: TransactionStoring) {
        self.store = store
    }

    func load() -> Result<Void, AppError> {
        do {
            try store.bootstrapIfNeeded()
            items = store.transactions
            return .success(())
        } catch let e as AppError {
            return .failure(e)
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }

    func formattedDate(for tx: Transaction) -> String {
        guard let d = tx.date else { return tx.dateISO }
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df.string(from: d)
    }

    func formattedAmount(for tx: Transaction) -> String {
        let sign = tx.amount >= 0 ? "+" : "-"
        return String(format: "%@$%.2f", sign, abs(tx.amount))
    }
}
