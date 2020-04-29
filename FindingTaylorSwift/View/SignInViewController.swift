//
//  SignInViewController.swift
//  FindingTaylorSwift
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import UIKit

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

        if userNameString.isBlank {
            userName.layer.borderWidth = 2
            userName.layer.borderColor = UIColor.blue.cgColor
        }

        if passwordString.isBlank {
            password.layer.borderWidth = 2
            password.layer.borderColor = UIColor.blue.cgColor
        }

        if !userNameString.isBlank && !passwordString.isBlank {

            awsUserPool.userLogin(userName: userNameString, password: passwordString)
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
}
