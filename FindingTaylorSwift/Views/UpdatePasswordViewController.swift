//
//  UpdatePasswordViewController.swift
//  FindingTaylorSwift
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import UIKit

class UpdatePasswordViewController: UIViewController {
    @IBOutlet var confirmationCode: UITextField!
    @IBOutlet var password: UITextField!
    weak var awsUserPool: AWSUserPool!
    var awsUserName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.738589704, blue: 0.9438112974, alpha: 1)
        self.navigationItem.title = "Forgot Password"
        view.backgroundColor = #colorLiteral(red: 1, green: 0.738589704, blue: 0.9438112974, alpha: 1)
    }

    @IBAction func updatePasword(_ sender: UIButton) {

        guard let newConfirmationCode = confirmationCode.text else { return }
        guard let newPassword = password.text else { return }

        if !newConfirmationCode.isNumber || newConfirmationCode.isBlank {
            confirmationCode.layer.borderWidth = 2
            confirmationCode.layer.borderColor = UIColor.blue.cgColor
            showAlert(title: ConfirmatiionCodeValidationError.title, message: ConfirmatiionCodeValidationError.message)
            return
        }

        if newPassword.isBlank {
            password.layer.borderWidth = 2
            password.layer.borderColor = UIColor.blue.cgColor
            showAlert(title: PasswordValidationError.title, message: PasswordValidationError.message)
            return
        }

        guard let confirmationCodeNumber = Int(newConfirmationCode) else { return }

        if newConfirmationCode.isNumber && !newPassword.isBlank {

            awsUserPool.updatePasswordWithConfirmationCode(username: awsUserName, newPassword: newPassword, confirmationCode: confirmationCodeNumber)
            confirmationCode.text = ""
            password.text = ""
            confirmationCode.layer.borderWidth = 0
            password.layer.borderWidth = 0
        }
    }

    private func showAlert(title: String, message: String) {

        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { _ in

            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
