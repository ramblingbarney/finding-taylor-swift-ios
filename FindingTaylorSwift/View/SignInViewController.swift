//
//  SignInViewController.swift
//  FindingTaylorSwift
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import UIKit
import RxSwift

class SignInViewController: UIViewController {

    @IBOutlet var userName: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var createNewAccount: UIButton!
    @IBOutlet var forgotYourPassword: UIButton!

    weak var awsUserPool: AWSUserPool!

    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.738589704, blue: 0.9438112974, alpha: 1)
        self.navigationItem.title = "Sign In"
        view.backgroundColor = #colorLiteral(red: 1, green: 0.738589704, blue: 0.9438112974, alpha: 1)
    }

    @IBAction func signIn(_ sender: UIButton) {

        guard let userNameString = userName.text else { return }
        guard let passwordString = password.text else { return }

        if !userNameString.validateEmail {
            userName.layer.borderWidth = 2
            userName.layer.borderColor = UIColor.blue.cgColor
            showAlert(title: EmailValidationError.title, message: EmailValidationError.message)
            return
        }

        if passwordString.isBlank {
            password.layer.borderWidth = 2
            password.layer.borderColor = UIColor.blue.cgColor
            showAlert(title: PasswordValidationError.title, message: PasswordValidationError.message)
            return
        }

        if userNameString.validateEmail && !passwordString.isBlank {

            awsUserPool.userLogin(userName: userNameString, password: passwordString)
            userName.text = ""
            password.text = ""
            userName.layer.borderWidth = 0
            password.layer.borderWidth = 0
        }

        if awsUserPool.userAuthenticationStatus != .signedIn {
            showAlert(title: LoginError.title, message: LoginError.message)
        }
    }

    @IBAction func createNewAccount(_ sender: UIButton) {

        print("create new account")
    }

    @IBAction func forgotYourPassword(_ sender: UIButton) {
        print("forgot your password")
    }

    @objc private func cancelSignIn(_ sender: AnyObject) {

        print("cancelled....")
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)

        // Set the Cancel screen Switch
        self.defaults.set(true, forKey: "cancelledSignInAWS")
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
