//
//  LoginViewModel.swift
//  TestExam
//
//  Created by Sabbir on 2/8/26.
//
import Foundation

final class LoginViewModel {
    private let authService: AuthServicing

    init(authService: AuthServicing) {
        self.authService = authService
    }

    func login(email: String, password: String) -> Result<User, AppError> {
        do {
            let user = try authService.login(email: email, password: password)
            return .success(user)
        } catch let e as AppError {
            return .failure(e)
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }
}

