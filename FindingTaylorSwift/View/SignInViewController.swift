//
//  SignInViewController.swift
//  FindingTaylorSwift
//
//  Created by The App Experts on 22/04/2020.
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.738589704, blue: 0.9438112974, alpha: 1)
        self.navigationItem.title = "Sign In"

        let cancelItem = UIBarButtonItem(
            title: "Cancel", style: .done, target: self, action: #selector(cancelSignIn))
        self.navigationItem.leftBarButtonItem = cancelItem
        cancelItem.tintColor = .white
    }

    @objc private func cancelSignIn(_ sender: AnyObject) {

        print("cancelled....")
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)

        // Set the Cancel screen Switch
        self.defaults.set(true, forKey: "cancelledSignInAWS")
    }
}
