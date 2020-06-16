//
//  ForgotPasswordEmailViewController.swift
//  FindingTaylorSwift
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import UIKit

class ForgotPasswordEmailViewController: UIViewController {

    @IBOutlet var emailUsername: UITextField!
    @IBOutlet var sendConfirmationCode: UIButton!
    var awsUserPool: AWSUserPool!
    var emailAddress: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.738589704, blue: 0.9438112974, alpha: 1)
        self.navigationItem.title = "Forgot Password"
        view.backgroundColor = #colorLiteral(red: 1, green: 0.738589704, blue: 0.9438112974, alpha: 1)
    }

    @IBAction func sendConfirmationCodeClick(_ sender: UIButton) {

        if emailUsername.text != nil {
            emailAddress = emailUsername.text
        }
        awsUserPool.forgotPasswordGetConfirmationCode(username: emailAddress)
        self.performSegue(withIdentifier: AWSControllers.forgotPasswordUpdate, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == AWSControllers.forgotPasswordUpdate {
            if let nextViewController = segue.destination as? UpdatePasswordViewController {
                nextViewController.awsUserPoolUpdatePassword = awsUserPool
            }
        }
    }
}
