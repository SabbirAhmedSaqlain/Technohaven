//
//  AlertPresenter.swift
//  TestExam
//
//  Created by Sabbir on 2/8/26.
//

import UIKit

enum AlertPresenter {
    static func showOk(on vc: UIViewController, title: String, message: String) {
        let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "OK", style: .default))
        vc.present(a, animated: true)
    }
}
