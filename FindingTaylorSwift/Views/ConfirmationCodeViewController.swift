//
//  ConfirmationCodeViewController.swift
//  FindingTaylorSwift
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import UIKit

class ConfirmationCodeViewController: UIViewController {

    var userName: String!
    weak var awsUserPoolConfirmationCode: AWSUserPool!

    @IBOutlet var confirmationCode: UITextField!
    @IBOutlet var submitConfirmationCode: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func submitConfirmationCode(_ sender: UIButton) {

        guard let confirmationCodeEntered = confirmationCode.text else { return }

        if !confirmationCodeEntered.isNumber || confirmationCodeEntered.isBlank {
            confirmationCode.layer.borderWidth = 2
            confirmationCode.layer.borderColor = UIColor.blue.cgColor
            showAlert(title: ConfirmatiionCodeValidationError.title, message: ConfirmatiionCodeValidationError.message)
            return
        }

        if !confirmationCodeEntered.isBlank && confirmationCodeEntered.isNumber {
            self.awsUserPoolConfirmationCode.confirmSignUp(username: userName, confirmationCode: confirmationCodeEntered)
        }

        _ = self.awsUserPoolConfirmationCode.userConfirmSignUpResult?
            .subscribe({ resultText in
                guard let elementContent = resultText.element?.signUpConfirmationState else { return }

                switch elementContent {
                case .confirmed:
                    self.transitionToLogin()
                default:
                    self.showAlert(title: ConfirmatiionCodeError.title, message: ConfirmatiionCodeError.message)
                }
            })
    }

    private func transitionToLogin() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: AWSControllers.awsConfirmSignUpUserSuccess, sender: self)
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
