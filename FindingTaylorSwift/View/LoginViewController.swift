//
//  LoginViewController.swift
//  FindingTaylorSwift
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!

    var oAuthViewModel = OAuthListViewModel(providers: OAuthProviders.providers)
    var oAuthUrl: URL!
    var webAuthSession: ASWebAuthenticationSession?

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
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(CustomCell.self, forCellReuseIdentifier: TextCellIdentifier.textCellIdentifier)
        self.tableView.tableFooterView = UIView()
    }
}

extension LoginViewController {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oAuthViewModel.providerList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextCellIdentifier.textCellIdentifier, for: indexPath) as! CustomCell

        let row = indexPath.row
        cell.backgroundColor = #colorLiteral(red: 1, green: 0.738589704, blue: 0.9438112974, alpha: 1)
        cell.buttonLabel.text = oAuthViewModel.providerList[row]
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        do {
            oAuthUrl = try oAuthViewModel.createOAuthUrl(providerName: oAuthViewModel.providerList[indexPath.row])

            getAuthTokenWithWebLogin(authURL: oAuthUrl)
        } catch {
            print("URL Request Failed")
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension LoginViewController: ASWebAuthenticationPresentationContextProviding {

        func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
            return self.view.window ?? ASPresentationAnchor()
        }

        @available(iOS 13.0, *)
        func getAuthTokenWithWebLogin(authURL: URL ) {

            let authURL = authURL
            let callbackUrlScheme = "findingtaylorswift.linkedin"

            self.webAuthSession = ASWebAuthenticationSession.init(url: authURL, callbackURLScheme: callbackUrlScheme, completionHandler: { (callBack: URL?, error: Error?) in

                // handle auth response
                guard error == nil, let successURL = callBack else {
                    return
                }

                let oauthToken = NSURLComponents(string: (successURL.absoluteString))?.queryItems?.filter({$0.name == "code"}).first

                // Do what you now that you've got the token, or use the callBack URL
                print(oauthToken ?? "No OAuth Token")
            })

            // New in iOS 13
            self.webAuthSession?.presentationContextProvider = self

            // Kick it off
            self.webAuthSession?.start()
        }
}

class CustomCell: UITableViewCell {

    var labelText: String?

    var buttonLabel: UILabel = {
        var label = UILabel()
        return label
    }()

    var buttonSeparator: UIView = {
        var separatorLine = UIView()
        separatorLine.backgroundColor = .white
        return separatorLine
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: TextCellIdentifier.textCellIdentifier)

        self.addSubview(buttonLabel)
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        buttonLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        buttonLabel.textColor = UIColor.white

        self.addSubview(buttonSeparator)
        buttonSeparator.translatesAutoresizingMaskIntoConstraints = false
        buttonSeparator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        buttonSeparator.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -0.0).isActive = true
        buttonSeparator.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -0.5).isActive = true
        buttonSeparator.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0).isActive = true
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
