//
//  Coordinator.swift
//  TestExam
//
//  Created by Sabbir on 2/8/26.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    func start()
}
