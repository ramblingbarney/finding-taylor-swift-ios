//
//  AccountViewController.swift
//  FindingTaylorSwift
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet var signOut: UIBarButtonItem!
    let defaults = UserDefaults.standard
    var awsUserPool: AWSUserPool!

    override func viewWillAppear(_ animated: Bool) {

        let seenSignIn = defaults.bool(forKey: "cancelledSignInAWS")

        if seenSignIn {

            self.tabBarController?.selectedIndex = 0
            self.defaults.set(false, forKey: "cancelledSignInAWS")
        }
        isUserAuthenticated()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.738589704, blue: 0.9438112974, alpha: 1)
        self.navigationItem.title = "My Account"
        self.awsUserPool = AWSUserPool.shared
    }

    private func isUserAuthenticated() {

        guard let currentAuthenticationStatus = self.awsUserPool.userAuthenticationStatus else {
            showAlert(title: AWSUserAuthenticationNil.title, message: AWSUserAuthenticationNil.message)
            return
        }

        if currentAuthenticationStatus != .signedIn {

            DispatchQueue.main.async {
                self.showSignIn()
            }
        }
    }

    private func showSignIn() {

        self.performSegue(withIdentifier: AWSControllers.signIn, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AWSControllers.signIn {
            if let nextViewController = segue.destination as? SignInViewController {
                nextViewController.awsUserPool = awsUserPool
            }
        }
    }

    @IBAction func signOutUser(_ sender: UIBarButtonItem) {
        awsUserPool.userLogout()
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
