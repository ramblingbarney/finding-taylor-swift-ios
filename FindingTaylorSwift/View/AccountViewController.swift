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

//    @IBOutlet var signOutButton: UIBarButtonItem!
    let defaults = UserDefaults.standard
//    var awsUserPool: AWSUserPool!

//    override func viewWillAppear(_ animated: Bool) {
//
//        let seenSignIn = defaults.bool(forKey: "cancelledSignInAWS")
//
//        if seenSignIn {
//
//            self.tabBarController?.selectedIndex = 0
//            self.defaults.set(false, forKey: "cancelledSignInAWS")
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.738589704, blue: 0.9438112974, alpha: 1)
        self.navigationItem.title = "My Account"
//        self.awsUserPool = AWSUserPool()
//        isUserAuthenticated()
    }

//    private func isUserAuthenticated() {
//
//        guard let currentAuthenticationStatus = self.awsUserPool.userAuthenticationStatus else {
//
//            // show an alert box "backend failure world ended try again later"
//            return
//        }
//
//        if currentAuthenticationStatus != .signedIn {
//
//            DispatchQueue.main.async {
//                self.showSignIn()
//            }
//        }
//    }

    private func showSignIn() {
//        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//          if let destination = segue.destination as? SignInViewController {
//            destination.awsUserPool = awsUserPool
//          }
//        }
//        let awsSignInViewController = self.storyboard!.instantiateViewController(withIdentifier: AWSControllers.signIn)
//        self.navigationController!.pushViewController(awsSignInViewController, animated: true)
    }

//    @IBAction func signOut(_ sender: UIBarButtonItem) {

//        awsUserPool.userLogout()
//    }
}
