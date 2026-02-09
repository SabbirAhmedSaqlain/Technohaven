//
//  MockTransactionLoader.swift
//  TestExam
//
//  Created by Sabbir on 2/8/26.
//

import Foundation

protocol TransactionLoading {
    func loadInitialTransactions() throws -> [Transaction]
}

final class MockTransactionLoader: TransactionLoading {
    private let bundle: Bundle
    private let resourceName: String

    init(bundle: Bundle = .main, resourceName: String = "transactions") {
        self.bundle = bundle
        self.resourceName = resourceName
    }

    func loadInitialTransactions() throws -> [Transaction] {
        guard let url = bundle.url(forResource: resourceName, withExtension: "json") else {
            throw AppError.dataLoadFailed
        }
        let data = try Data(contentsOf: url)
        do {
            return try JSONDecoder().decode([Transaction].self, from: data)
        } catch {
            throw AppError.dataLoadFailed
        }
    }
}
