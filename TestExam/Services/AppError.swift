//
//  AppError.swift
//  TestExam
//
//  Created by Sabbir on 2/8/26.
//

import Foundation

enum AppError: LocalizedError, Equatable {
    case invalidEmail
    case passwordTooShort
    case invalidCredentials
    case receiverIdEmpty
    case amountInvalid
    case insufficientFunds
    case dataLoadFailed
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .invalidEmail: return "Please enter a valid email."
        case .passwordTooShort: return "Password must be at least 6 characters."
        case .invalidCredentials: return "Incorrect email or password."
        case .receiverIdEmpty: return "Receiver ID is required."
        case .amountInvalid: return "Amount must be greater than zero."
        case .insufficientFunds: return "Insufficient balance."
        case .dataLoadFailed: return "Failed to load transactions."
        case .unknown(let msg): return msg
        }
    }
}
