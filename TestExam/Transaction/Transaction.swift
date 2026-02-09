//
//  Transaction.swift
//  TestExam
//
//  Created by Sabbir on 2/8/26.
//

import Foundation

struct Transaction: Codable, Equatable {
    let id: String
    let dateISO: String
    let title: String
    let amount: Double

    var date: Date? {
        ISO8601DateFormatter().date(from: dateISO)
    }
}
