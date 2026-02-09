
//
//  TransactionStore..swift
//  TestExam
//
//  Created by Sabbir on 2/8/26.
//

import Foundation

protocol TransactionStoring: AnyObject {
    var user: User? { get }
    var transactions: [Transaction] { get }

    func bootstrapIfNeeded() throws
    func logout()

    func currentBalance() -> Money
    func append(_ tx: Transaction)
    func updateBalance(_ newBalance: Money)
}

final class TransactionStore: TransactionStoring {
    private let session: InMemorySessionStore
    private let loader: TransactionLoading

    private(set) var transactions: [Transaction] = []
    private var bootstrapped = false

    init(session: InMemorySessionStore, loader: TransactionLoading) {
        self.session = session
        self.loader = loader
    }

    var user: User? { session.currentUser }

    func bootstrapIfNeeded() throws {
        guard !bootstrapped else { return }
        transactions = try loader.loadInitialTransactions()
        bootstrapped = true
    }

    func logout() {
        transactions = []
        bootstrapped = false
        session.clear()
    }

    func currentBalance() -> Money {
        session.currentUser?.balance ?? 0
    }

    func append(_ tx: Transaction) {
        transactions.insert(tx, at: 0)
    }

    func updateBalance(_ newBalance: Money) {
        guard var u = session.currentUser else { return }
        u.balance = newBalance
        session.set(user: u)
    }
}
