//
//  InMemorySessionStore.swift
//  TestExam
//
//  Created by Sabbir on 2/8/26.
//

import Foundation

final class InMemorySessionStore {
    private(set) var currentUser: User?

    func set(user: User) {
        currentUser = user
    }

    func clear() {
        currentUser = nil
    }
}
