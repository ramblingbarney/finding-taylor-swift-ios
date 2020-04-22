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
        //        showSignIn()
        initalizeAWSMobileClient()
    }

    private func showSignIn() {

        let awsSignInViewController = self.storyboard!.instantiateViewController(withIdentifier: AWSControllers.signIn)
        self.navigationController!.pushViewController(awsSignInViewController, animated: true)
    }
    //        AWSMobileClient.default().signIn(username: "c9dw5er@protonmail.com", password: "test12345") { (signInResult, error) in
    //            if let error = error {
    //                print("\(error.localizedDescription)")
    //            } else if let signInResult = signInResult {
    //                switch signInResult.signInState {
    //                case .signedIn:
    //                    print("User is signed in.")
    //                case .smsMFA:
    //                    print("SMS message sent to \(signInResult.codeDetails!.destination!)")
    //                default:
    //                    print("Sign In needs info which is not yet supported.")
    //                }
    //            }

    //        AWSMobileClient.default().showSignIn(navigationController: self.navigationController!,
    //                                             signInUIOptions: SignInUIOptions(
    //                                                canCancel: true,
    //                                                logoImage: UIImage(systemName: "person.circle"),
    //                                                backgroundColor: #colorLiteral(red: 1, green: 0.738589704, blue: 0.9438112974, alpha: 1),
    //                                                secondaryBackgroundColor: .white,
    //                                                primaryColor: #colorLiteral(red: 1, green: 0.738589704, blue: 0.9438112974, alpha: 1),
    //                                                disableSignUpButton: false)) { (_, error ) in
    //                                                    if error == nil {
    //                                                        DispatchQueue.main.async {
    //                                                            print("User successfully logged in")
    //                                                        }
    //                                                    }
    //        }

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
}
