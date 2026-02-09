//
//  AuthService.swift
//  TestExam
//
//  Created by Sabbir on 2/8/26.
//

import Foundation

protocol AuthServicing {
    func login(email: String, password: String) throws -> User
}

final class AuthService: AuthServicing {
    private let session: InMemorySessionStore

    init(session: InMemorySessionStore) {
        self.session = session
    }

    func login(email: String, password: String) throws -> User {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard Self.isValidEmail(trimmed) else { throw AppError.invalidEmail }
        guard password.count >= 6 else { throw AppError.passwordTooShort }

        // Mock credentials (from assignment)
        guard trimmed.lowercased() == "test@app.com", password == "123456" else {
            throw AppError.invalidCredentials
        }

        // Create a mock user
        let user = User(
            fullName: "Test User",
            accountId: "ACCT-100200",
            balance: 500.00,
            email: trimmed.lowercased()
        )
        session.set(user: user)
        return user
    }

    private static func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }
}
