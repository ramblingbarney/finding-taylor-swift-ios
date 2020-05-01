//
//  AWSUserPool.swift
//  FindingTaylorSwift
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import Foundation
import AWSAuthCore
import AWSAuthUI
import AWSMobileClient
import UIKit

class AWSUserPool {

    var userAuthenticationStatus: UserAuthenticationState?
    var userAuthenticationError: String?

    internal init() {

        initalizeAWSMobileClient()
    }

    static let shared = AWSUserPool()

    private func initalizeAWSMobileClient() {

        AWSMobileClient.default().initialize { (userState, error ) in

            if let userState = userState {
                switch userState {
                case .signedIn:
                    print("Logged In")
                    print("Cognito Identity Id (authenticated): \(String(describing: AWSMobileClient.default().identityId))")
                    self.userAuthenticationStatus = .signedIn
                case .signedOut:
                    print("Logged Out")
                    self.userAuthenticationStatus = .signedOut
                case .signedOutUserPoolsTokenInvalid:
                    print("User Pools refresh token is invalid or expired.")
                    self.userAuthenticationStatus = .signedOutUserPoolsTokenInvalid
                case .signedOutFederatedTokensInvalid:
                    print("Federated refresh token is invalid or expired.")
                    self.userAuthenticationStatus = .signedOutFederatedTokensInvalid
                default:
                    self.userAuthenticationStatus = .signedOut
                    AWSMobileClient.default().signOut()
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    internal func userLogin(userName: String, password: String) {

        AWSMobileClient.default().signIn(username: userName, password: password) { (signInResult, error) in
            if let error = error {
                print("\(error.localizedDescription)")
                self.userAuthenticationError = error.localizedDescription

            } else if let signInResult = signInResult {
                switch signInResult.signInState {
                case .signedIn:
                    print("User is signed in.")
                    self.userAuthenticationStatus = .signedIn
                case .smsMFA:
                    print("SMS message sent to \(signInResult.codeDetails!.destination!)")
                default:
                    print("Sign In needs info which is not yet supported.")
                }
            }
        }
    }

    internal func userLogout() {
        AWSMobileClient.default().signOut()
    }
}
