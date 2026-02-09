//
//  SendFundsViewModel.swift
//  TestExam
//
//  Created by Sabbir on 2/8/26.
//

import Foundation

final class SendFundsViewModel {
    private let store: TransactionStoring

    init(store: TransactionStoring) {
        self.store = store
    }

    func send(receiverId: String, amountText: String) -> Result<String, AppError> {
        let receiver = receiverId.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !receiver.isEmpty else { return .failure(.receiverIdEmpty) }

        let cleaned = amountText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let amountDouble = Double(cleaned), amountDouble > 0 else { return .failure(.amountInvalid) }

        let current = NSDecimalNumber(decimal: store.currentBalance()).doubleValue
        guard amountDouble <= current else { return .failure(.insufficientFunds) }

        let newBalance = Decimal(current - amountDouble)
        store.updateBalance(newBalance)

        let iso = ISO8601DateFormatter().string(from: Date())
        let tx = Transaction(
            id: UUID().uuidString,
            dateISO: iso,
            title: "Transfer to \(receiver)",
            amount: -amountDouble
        )
        store.append(tx)

        return .success(String(format: "Sent $%.2f to %@", amountDouble, receiver))
    }
}
