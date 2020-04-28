//
//  AccountViewController.swift
//  FindingTaylorSwift
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSAuthUI
import AWSMobileClient

class AccountViewController: UIViewController {

    @IBOutlet var signOut: UIBarButtonItem!
    let defaults = UserDefaults.standard

    override func viewWillAppear(_ animated: Bool) {

        let seenSignIn = defaults.bool(forKey: "cancelledSignInAWS")

        if seenSignIn {

            self.tabBarController?.selectedIndex = 0
            self.defaults.set(false, forKey: "cancelledSignInAWS")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.738589704, blue: 0.9438112974, alpha: 1)
        self.navigationItem.title = "My Account"
        initalizeAWSMobileClient()
    }

    private func showSignIn() {

        self.performSegue(withIdentifier: AWSControllers.signIn, sender: self)
    }

    private func initalizeAWSMobileClient() {

        AWSMobileClient.default().initialize { (userState, error ) in

            if let userState = userState {
                switch userState {
                case .signedIn:
                    print("Logged In")
                    print("Cognito Identity Id (authenticated): \(String(describing: AWSMobileClient.default().identityId))")
                    AWSMobileClient.default().signOut()
                case .signedOut:
                    print("Logged Out")
                    DispatchQueue.main.async {
                        self.showSignIn()
                    }
                case .signedOutUserPoolsTokenInvalid:
                    print("User Pools refresh token is invalid or expired.")
                    DispatchQueue.main.async {
                        self.showSignIn()
                    }
                case .signedOutFederatedTokensInvalid:
                    print("Federated refresh token is invalid or expired.")
                    DispatchQueue.main.async {
                        self.showSignIn()
                    }
                default:
                    AWSMobileClient.default().signOut()
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "awsSignInController" {
            if let nextViewController = segue.destination as? SignInViewController {
                    nextViewController.awsUserPool = "XYZ"
            }
        }
    }

    @IBAction func signOutUser(_ sender: UIBarButtonItem) {
        //awsUserPool.userLogout()
        print("sign out sign out sign out")
    }
}
