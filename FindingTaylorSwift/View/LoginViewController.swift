//
//  LoginViewController.swift
//  FindingTaylorSwift
//
//  Created by The App Experts on 11/03/2020.
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!

    var providerButtons = OAuthListViewModel(providers: OAuthProviders.providers)

    override func viewDidLoad() {
        super.viewDidLoad()

        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.738589704, blue: 0.9438112974, alpha: 1)
        self.navigationItem.title = "LOGIN / SIGNUP"
        self.navigationItem.leftBarButtonItem?.tintColor = .white
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.tableView.separatorColor = .white
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(CustomCell.self, forCellReuseIdentifier: TextCellIdentifier.textCellIdentifier)
        self.tableView.layoutMargins = UIEdgeInsets.zero
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.tableFooterView = UIView()
    }
}

extension LoginViewController {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return providerButtons.providerList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextCellIdentifier.textCellIdentifier, for: indexPath) as! CustomCell

        let row = indexPath.row
        cell.backgroundColor = #colorLiteral(red: 1, green: 0.738589704, blue: 0.9438112974, alpha: 1)
        cell.buttonLabel.text = providerButtons.providerList[row]
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print(providerButtons.providerList[indexPath.row])
    }
}

class CustomCell: UITableViewCell {

    var labelText: String?

    var buttonLabel: UILabel = {
        var label = UILabel()
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: TextCellIdentifier.textCellIdentifier)
        self.addSubview(buttonLabel)
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false

        buttonLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        buttonLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        buttonLabel.textColor = UIColor.white
    }

    override func layoutSubviews() {

        if let labelText = labelText {
            buttonLabel.text = labelText
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
