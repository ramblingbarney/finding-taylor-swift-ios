//
//  LoginViewController.swift
//  FindingTaylorSwift
//
//  Created by The App Experts on 11/03/2020.
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.738589704, blue: 0.9438112974, alpha: 1)
        self.navigationItem.title = "LOGIN / SIGNUP"
        self.navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.leftBarButtonItem?.isEnabled = false
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none

    }
}
