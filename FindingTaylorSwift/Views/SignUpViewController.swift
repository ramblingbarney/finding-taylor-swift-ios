//
//  SignUpViewController.swift
//  FindingTaylorSwift
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet var emailAddress: UITextField!
    @IBOutlet var passwordOne: UITextField!
    @IBOutlet var passwordTwo: UITextField!
    @IBOutlet var createAccountButton: UIButton!
    var emailAddressToValidate: String!
    weak var awsUserPoolSignUp: AWSUserPool!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func createAccount(_ sender: UIButton) {

        self.emailAddressToValidate = emailAddress.text
        guard let passwordOneToValidate = passwordOne.text else { return }
        guard let passwordTwoToValidate = passwordTwo.text else { return }

        if !emailAddressToValidate.validateEmail {
            emailAddress.layer.borderWidth = 2
            emailAddress.layer.borderColor = UIColor.blue.cgColor
            showAlert(title: EmailValidationError.title, message: EmailValidationError.message)
            return
        }

        if !passwordOneToValidate.validatePassword {
            passwordOne.layer.borderWidth = 2
            passwordOne.layer.borderColor = UIColor.blue.cgColor
            showAlert(title: PasswordValidationError.title, message: PasswordValidationError.message)
            return
        }

        if !passwordTwoToValidate.validatePassword {
            passwordTwo.layer.borderWidth = 2
            passwordTwo.layer.borderColor = UIColor.blue.cgColor
            showAlert(title: PasswordValidationError.title, message: PasswordValidationError.message)
            return
        }

        if passwordOneToValidate != passwordTwoToValidate {
            passwordOne.layer.borderWidth = 2
            passwordOne.layer.borderColor = UIColor.blue.cgColor
            passwordTwo.layer.borderWidth = 2
            passwordTwo.layer.borderColor = UIColor.blue.cgColor
            showAlert(title: PasswordValidationErrorMatching.title, message: PasswordValidationErrorMatching.message)
            return
        }

        if emailAddressToValidate.validateEmail && !passwordOneToValidate.isBlank && !passwordOneToValidate.isBlank && passwordOneToValidate.validatePassword && passwordTwoToValidate.validatePassword {

            awsUserPoolSignUp.createUser(userName: emailAddressToValidate, password: passwordOneToValidate)
            emailAddress.text = ""
            passwordOne.text = ""
            passwordTwo.text = ""
            emailAddress.layer.borderWidth = 0
            passwordOne.layer.borderWidth = 0
            passwordTwo.layer.borderWidth = 0
        }

        _ = self.awsUserPoolSignUp.userSignUpError?
            .subscribe({ errorText in
                guard let elementContent = errorText.element?.localizedDescription else { return }

                switch elementContent {
                case "The operation couldn’t be completed. (AWSMobileClient.AWSMobileClientError error 8.)":
                    self.transitionToLogin()
                case "The operation couldn’t be completed. (AWSMobileClient.AWSMobileClientError error 24.)":
                    self.showAlertResend(title: CreateAccountError.titleSignUp, message: CreateAccountError.messageCreateAccountEmailReegistered)
                default:
                    self.showAlert(title: CreateAccountError.titleSignUp, message: elementContent)
                }
            })
    }

    private func transitionToLogin() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }

    private func showAlertResend(title: String, message: String) {

        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "CANCEL", style: .cancel) { _ in

            }
            let RESENDAction = UIAlertAction(title: "Resend Confirmation Code", style: .default) { _ in

                self.awsUserPoolSignUp.resendCode(username: self.emailAddressToValidate)
            }
            alertController.addAction(OKAction)
            alertController.addAction(RESENDAction)
            self.present(alertController, animated: true, completion: nil)
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
